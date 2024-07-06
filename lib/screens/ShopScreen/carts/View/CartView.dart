import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/ShopScreen/carts/Model/CartModel.dart';
import 'package:ofline_app/screens/ShopScreen/carts/View/CustomBottomSheet.dart';

import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';
import 'package:ofline_app/utility/Constants/string_extensions.dart';
import '../../../../../utility/Constants/color.dart';

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
 
    
    

    @override
    Widget build(BuildContext context) {
      var mqw = MediaQuery.of(context).size.width;
      var mqh = MediaQuery.of(context).size.height;

    return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => 
                              Custombottomsheet(shop: widget.shop, customerId: widget.customerId)
                      ),
                  );
            },
            child: Container(
              height: mqh * 0.044,
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
                          "0",
                          // cartmdel!.total_amount.toString(),
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
                          'Rupe',
                          // '₹' + cartmdel!.total_cart_item.toString(),
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
          );
  
  }
  
}