import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/ShopScreen/carts/CartModel.dart';

import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';
import 'package:ofline_app/utility/Constants/string_extensions.dart';
import '../../../../utility/Constants/color.dart';

class Cartview extends StatefulWidget {
  final ShopModel shop;
  final String customerId;
 

  const Cartview(
      {Key? key,
      required this.shop,
      required this.customerId,
      })
      : super(key: key);

  @override
  State<Cartview> createState() => _CartviewState();
}

class _CartviewState extends State<Cartview> {
  String groupValue = 'Dine In';
  final _firestore = FirebaseFirestore.instance;
  late Cartmodel? cartmdel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartStream();
  }

 
void UpdateItemCount(int index,int qty) async {
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
      List<Map<String,dynamic>> cartlist = List.from(snapshot.get('cart_items') ?? []);
      
      if (index < 0 || index >= cartlist.length) {
        throw Exception("Index out of bounds");
      }

      
      Map<String,dynamic> item = cartlist[index];
      
     

      // Increment the 'Count'
      item['cart_product_qty'] += qty;
      print("hell");

      // Replace the old item with the updated item
      cartlist[index] = item;

      // Update the document with the new array
      transaction.update(docRef, {'cart_items': cartlist });
    });

    print("Item count updated successfully.");
  } catch (e) {
    print("Failed to increment item count: $e");
  }
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

  @override
  Widget build(BuildContext context) {
    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;

    return StreamBuilder<Cartmodel?>(
      stream: cartStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text("No Cart Found"));
        }
        cartmdel = snapshot.data as Cartmodel ;
        return Container(
      width: double.infinity,
      height: mqh * 140 / 2340,
      decoration: const BoxDecoration(
        color: kWhite,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.5, 1.00),
            color: Color.fromRGBO(230, 230, 231, 0.3),
            blurRadius: 2.0,
          ),
          BoxShadow(
            offset: Offset(-1, 0.3),
            color: Color.fromRGBO(125, 125, 125, 0.15),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Padding(
          padding: EdgeInsets.only(
              left: mqw * 230 / 1080,
              top: mqh * 30 / 2340,
              right: mqw * 250 / 1080),
          child: GestureDetector(
            onTap: () {
              bottomSheet();
            },
            child: Container(
              height: mqh * 0.049,
              width: mqw * 400 / 1080,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.5)),
                  color: kBlue),
              child: Padding(
                  padding: EdgeInsets.all(mqw * 10 / 1080),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          cartmdel!.total_amount.toString(),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: mqw * 100 / 1080,
                          child: Icon(
                            Icons.shopping_cart,
                            color: kWhite,
                            size: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '₹' + cartmdel!.total_cart_item.toString(),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          )),
    );
 
      },
    );
  }
  
  void bottomSheet(){
    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    showModalBottomSheet(
                  context: context,          
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                      return Container(
                      width: double.infinity,
                      height: mqh * 1800 / 2340,
                      decoration: const BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(widget.shop.shop_name.toTitleCase() + cartmdel!.total_amount.toString(),
                                style: const TextStyle(
                                    color: kBlue,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5)),
                          ),
                          Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: cartmdel!.items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  CartItem item = cartmdel!.items[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: mqh * 20 / 2340,
                                        bottom: mqh * 35 / 2340,
                                        right: mqw * 40 / 1080,
                                        left: mqw * 40 / 1080),
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
                                                width: mqw * 250/ 1080,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.cart_product_name.toTitleCase(),
                                                      maxLines: 2,
                                                      textDirection:
                                                      TextDirection.ltr,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14.7,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: kGrey),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text('₹${item.cart_product_price}',
                                                        textDirection:
                                                        TextDirection.ltr,
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                            color: kGrey,
                                                            fontSize: 13.5,
                                                            fontWeight:
                                                            FontWeight.w500))
                                                  ],
                                                ),
                                              )
                                            ),
                                            Container(
                                              width: mqw * 150 / 1080,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: mqw * 10 / 1080),
                                                  child: Text('${item.cart_product_sizeVariant=='size' ? "" : item.cart_product_sizeVariant}'.toTitleCase(),
                                                      textDirection:
                                                      TextDirection.ltr,
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          color: kGrey,
                                                          fontSize: 13.5,
                                                          fontWeight:
                                                          FontWeight.w500))),
                                            ),
                                            Text('₹${item.cart_total_product_price}',
                                                textDirection:
                                                    TextDirection.ltr,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    color: kGrey,
                                                    fontSize: 13.5,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: mqw * 35 / 1080),
                                              child: Container(
                                                height: mqh * 80 / 2340,
                                                width: mqw * 205 / 1080,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(7)),
                                                    color: kBlue),
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
                                                          UpdateItemCount(index, -1);
                                                          setState((){

                                                          });
                                                          // setState(() {
                                                          //   print(
                                                          //       "Before increment: ${item.product_qty}");
                                                          //   item.product_qty -=
                                                          //       1;
                                                          //   print(
                                                          //       "After increment: ${item.product_qty}");
                                                          // });

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

                                                          UpdateItemCount(index, 1);
                                                          setState((){

                                                          });
                                                          // setState(() {
                                                          //   print("Before increment: ${item.product_qty}");
                                                          //   item.product_qty += 1;
                                                          //   print("After increment: ${item.product_qty}");
                                                          // });
                                                        },
                                                        child: Icon(
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
                                        )),
                                    ),
                                  );
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: mqw * 70 / 1080),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: mqw * 300 / 1080,
                                  child: Row(
                                    children: [
                                      Radio(
                                          activeColor: groupValue=='Dine in' ? kBlue : kGrey,
                                          value: 'Dine In',
                                          groupValue: groupValue,
                                          onChanged: (value) {
                                            setState(() {
                                              groupValue = value!;
                                            });
                                          }),
                                      Text(
                                        'Dine In',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: groupValue=='Dine in' ? kBlue : kGrey),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: mqw * 400 / 1080,
                                  child: Row(
                                    children: [
                                      Radio(
                                          activeColor: groupValue=='Takeaway' ? kBlue : kGrey,
                                          value: 'Takeaway',
                                          groupValue: groupValue,
                                          onChanged: (value) {
                                            setState(() {
                                              groupValue = value!;
                                            });
                                          }),
                                      Text(
                                        'Takeaway',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: groupValue=='Takeaway' ? kBlue : kGrey),
                                      ),
                                    ],
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
                                      color: kGrey.withOpacity(0.25)),
                                ),
                                Text(
                                  'Shine Jaiswal',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: kGrey.withOpacity(0.25)),
                                ),
                                Icon(
                                  Icons.content_copy,
                                  size: 16,
                                  color: kGrey.withOpacity(0.40),
                                )
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
                                      const Text(
                                        '₹9000',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: kGrey),
                                      ),
                                      SizedBox(width: mqw * 10 / 1080),
                                      const Icon(
                                        Icons.info_outline_rounded,
                                        color: kGrey,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: mqw * 210 / 1080,
                                ),
                                Container(
                                  height: mqh * 100 / 2340,
                                  width: mqw * 275 / 1080,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: kBlue),
                                  child: const Center(
                                    child: Text(
                                      'Pre-order',
                                      style: TextStyle(
                                        color: kWhite,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                    });
                  }
                  );
  }
   
}