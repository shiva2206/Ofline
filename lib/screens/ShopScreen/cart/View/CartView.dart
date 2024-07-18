import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ofline_app/screens/ShopScreen/cart/Model/CartModel.dart';
import 'package:ofline_app/screens/ShopScreen/cart/Model/CartModel.dart';

import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';
import 'package:ofline_app/utility/Constants/string_extensions.dart';
import '../../../../../utility/Constants/color.dart';
import 'CustomBottomSheet.dart';

class Cartview extends StatefulWidget {
  final ShopModel shop;
  final String customerId;
  final Function  showOverlay;

  const Cartview({
    Key? key,
    required this.shop,
    required this.customerId,
    required List<CartItem> cart,
    required this.showOverlay
  }) : super(key: key);

  @override
  State<Cartview> createState() => _CartviewState();
}

class _CartviewState extends State<Cartview> {
  String groupValue = 'Dine In';
  final _firestore = FirebaseFirestore.instance;
  OverlayEntry? _overlayEntry;

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
    var itemCount = 0;
    var mqw = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        if (itemCount > 0) {
          widget.showOverlay(context);
        }
      },
      child: Center(
        child: Container(
            height: mqh * 0.05,
            width: mqw * 550 / 1080,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.5)),
                color: kBlue),
            child: StreamBuilder<Cartmodel?>(
              stream: cartStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                      child: Text(
                    "--",
                    style: TextStyle(color: kWhite),
                  ));
                } else {
                  itemCount = snapshot.data!.total_cart_item;
                  return Padding(
                      padding: EdgeInsets.all(mqw * 10 / 1080),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              snapshot.data!.total_cart_item.toString(),
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
                              child: const Icon(
                                Icons.shopping_cart,
                                color: kWhite,
                                size: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "₹${snapshot.data!.total_amount}",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: kWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ));
                }
              },
            )),
      ),
    );
  }
}