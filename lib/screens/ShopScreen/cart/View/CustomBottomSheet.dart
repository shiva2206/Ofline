import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';
import 'package:ofline_app/utility/Constants/string_extensions.dart';
import '../../../../../utility/Constants/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/CartModel.dart';

class Custombottomsheet extends StatefulWidget {
  final ShopModel shop;
  final String customerId;
  OverlayEntry? overlayEntry;
 

  Custombottomsheet(
      {super.key,
      required this.shop,
      required this.customerId,
      required this.overlayEntry,
     });

  @override
  State<Custombottomsheet> createState() => _CustombottomsheetState();
}

class _CustombottomsheetState extends State<Custombottomsheet> {
  final _firestore = FirebaseFirestore.instance;
  late Cartmodel? cartmdel;
  final ValueNotifier<bool> isCopiedNotifier = ValueNotifier(false);
  final ValueNotifier<String> groupValueNotifier = ValueNotifier<String>('Dine In');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartStream();
  }


  void UpdateItemCount(int index, int qty) async {
    // Get a reference to the specific cart document
    DocumentReference docRef = _firestore.collection('Cart').doc(cartmdel!.id);

    try {
      // Run a transaction to ensure atomic read and write
      await _firestore.runTransaction((transaction) async {
        // Get the current document snapshot
        DocumentSnapshot snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception("Document does not exist!");
        }

        // Read the current array from the snapshot
        List<Map<String, dynamic>> cartlist =
            List.from(snapshot.get('cart_items') ?? []);

        if (index < 0 || index >= cartlist.length) {
          throw Exception("Index out of bounds");
        }
        Map<String, dynamic> item = cartlist[index];

        // Increment the 'Count'
        item['cart_product_qty'] += qty;
        item['total_cart_product_price'] =
            item['cart_product_price'] * item['cart_product_qty'];

        var totalCartItem = snapshot.get('total_cart_item');
        totalCartItem += qty;
        var totalAmount = snapshot.get('total_amount');
        qty == 1
            ? totalAmount += item['cart_product_price']
            : totalAmount -= item['cart_product_price'];
        if (item['cart_product_qty'] <= 0) {
          cartlist.removeAt(index);
        } else {
          cartlist[index] = item;
        }

        print(totalAmount);

        // Update the document with the new array
        transaction.update(docRef, {
          'cart_items': cartlist,
          'total_cart_item': totalCartItem,
          'total_amount': totalAmount
        });
      });

      print("Item count updated successfully.");
    } catch (e) {
      print("Failed to increment item count: $e");
    }
  }

  void _storeShopId(String cartText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('shopId', widget.shop.id);
    Clipboard.setData(ClipboardData(text: cartText));
    isCopiedNotifier.value = true;
    Future.delayed(const Duration(seconds: 5), () {
      isCopiedNotifier.value = false;
    });
  }

  Stream<Cartmodel?> cartStream() {
    return FirebaseFirestore.instance
        .collection('Cart')
        .where('shop_id', isEqualTo: widget.shop.id)
        .where('customer_id', isEqualTo: widget.customerId)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty
            ? Cartmodel.fromFirestore(snapshot.docs.first)
            : null);
  }

  final player = AudioPlayer();

  void playsound() {
    player.stop();
    player.play(AssetSource('ofline_cart.mp3'));
  }

  @override
  void dispose() {
    player.release();
    player.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    widget.overlayEntry?.remove();
    widget.overlayEntry = null;
  }

  bool isPlayed = false;

  @override
  Widget build(BuildContext context) {
    int itemCount = 0;
    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<Cartmodel?>(
        stream: cartStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
                child: Text(
              "No Cart Found",
              style: TextStyle(color: kWhite),
            ));
          }
          cartmdel = snapshot.data as Cartmodel;
          itemCount = cartmdel!.items.length;
          if (itemCount==0)
            {
              _removeOverlay();
            }
          if (!isPlayed)
            {
              isPlayed = true;
              playsound();
            }
          print(isPlayed);
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GestureDetector(
                onTap: () {
                  _removeOverlay();
                },
                child: Container(
                  color: Colors.black26.withOpacity(0.5),
                  height: mqh,
                  width: double.infinity,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                height: mqh * 0.6,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                        child: Text(
                          widget.shop.shop_name.toTitleCase(),
                          style: const TextStyle(
                            color: kBlue,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mqh * 750 / 2340,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        itemCount: cartmdel!.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          CartItem item = cartmdel!.items[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: mqh * 20 / 2340,
                              horizontal: mqw * 40 / 1080,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10)),
                                color: kChipColor.withOpacity(0.35),
                              ),
                              height: mqh * 200 / 2340,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: mqw * 5 / 1080),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: mqw * 40 / 1080,
                                          top: mqh * 40 / 2340),
                                      child: Container(
                                        width: mqw * 250 / 1080,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.cart_product_name.toTitleCase(),
                                              maxLines: 1,
                                              textDirection:
                                              TextDirection.ltr,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14.7,
                                                fontWeight:
                                                FontWeight.w500,
                                                color: kGrey,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                                '₹${item.cart_product_price}',
                                                textDirection:
                                                TextDirection.ltr,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  color: kGrey,
                                                  fontSize: 13.5,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: mqw * 150 / 1080,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: mqw * 10 / 1080),
                                        child: Text(
                                          item.cart_product_sizeVariant ==
                                              'size'
                                              ? ""
                                              : item
                                              .cart_product_sizeVariant.toTitleCase(),
                                          textDirection:
                                          TextDirection.ltr,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: kGrey,
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                        '₹${item.cart_total_product_price}',
                                        textDirection: TextDirection.ltr,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: kGrey,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: mqw * 35 / 1080),
                                      child: Container(
                                        height: mqh * 80 / 2340,
                                        width: mqw * 205 / 1080,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7)),
                                          color: kBlue,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                              mqw * 20 / 1080),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  UpdateItemCount(
                                                      index, -1);
                                                },
                                                child: const Icon(
                                                  Icons.remove,
                                                  color: kWhite,
                                                  size: 19.5,
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  '${item.cart_product_qty}',
                                                  style: const TextStyle(
                                                    color: kWhite,
                                                    fontSize: 13.5,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  UpdateItemCount(
                                                      index, 1);
                                                },
                                                child: const Icon(
                                                  Icons.add,
                                                  color: kWhite,
                                                  size: 19.5,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: mqw * 70 / 1080),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: mqw * 300 / 1080,
                            child: ValueListenableBuilder<String>(
                              valueListenable: groupValueNotifier,
                              builder: (context, value, _) {
                                return Row(
                                  children: [
                                    Radio(
                                      activeColor: value == 'Dine In' ? kBlue : kGrey,
                                      value: 'Dine In',
                                      groupValue: value,
                                      onChanged: (selectedValue) {
                                        groupValueNotifier.value = selectedValue!;
                                      },
                                    ),
                                    Text(
                                      'Dine In',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: value == 'Dine In' ? kBlue : kGrey,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: mqw * 400 / 1080,
                            child: ValueListenableBuilder<String>(
                              valueListenable: groupValueNotifier,
                              builder: (context, value, _) {
                                return Row(
                                  children: [
                                    Radio(
                                      activeColor: value == 'Takeaway' ? kBlue : kGrey,
                                      value: 'Takeaway',
                                      groupValue: value,
                                      onChanged: (selectedValue) {
                                        groupValueNotifier.value = selectedValue!;
                                      },
                                    ),
                                    Text(
                                      'Takeaway',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: value == 'Takeaway' ? kBlue : kGrey,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: mqh * 30 / 2340,
                          left: mqw * 50 / 2340,
                          right: mqw * 35 / 1080),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'UPI',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: kGrey.withOpacity(0.25),
                            ),
                          ),
                          Text(
                            widget.shop.shop_merchant_name.toTitleCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: kGrey.withOpacity(0.25),
                            ),
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: isCopiedNotifier,
                            builder: (context, isCopied, _) {
                              return IconButton(
                                onPressed: () {
                                  _storeShopId(widget.shop.shop_upi);
                                },
                                icon: Icon(
                                  isCopied ? Icons.done : Icons.copy,
                                  color: isCopied ? kBlue : kGrey,
                                  size: isCopied ? 16 : 15,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: mqh * 65 / 2340,
                          left: mqw * 100 / 1080,
                          bottom: mqh * 15 / 2340),
                      child: Row(
                        children: [
                          SizedBox(
                            width: mqw * 400 / 1080,
                            child: Row(
                              children: [
                                Text(
                                  '₹${snapshot.data!.total_amount}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: kGrey,
                                  ),
                                ),
                                SizedBox(width: mqw * 10 / 1080),
                                const Icon(
                                  Icons.info_outline_rounded,
                                  color: kGrey,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: mqw * 210 / 1080,
                          ),
                          GestureDetector(
                            onTap: () {
                              print("True");
                            },
                            child: Container(
                              height: mqh * 100 / 2340,
                              width: mqw * 275 / 1080,
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                                color: cartmdel!.cart_payment_image!="" ? kBlue : kGrey,
                              ),
                              child:  Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      if(cartmdel!.cart_payment_image=="") return;


                                    },
                                    child: const Text(
                                      'Pre-order',
                                      style: TextStyle(
                                        color: kWhite  ,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}