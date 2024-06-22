import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/ShopScreen/products/View/productView.dart';
import 'package:ofline_app/utility/Constants/color.dart';
import 'package:ofline_app/utility/Location/Model/locationModel.dart';
import 'package:ofline_app/utility/Location/ViewModel/locationViewModel.dart';

class ShopCard extends ConsumerStatefulWidget {
  ShopCard({super.key,required this.shop,required this.mqh,required this.mqw});
  final shop;
  final mqh,mqw;
  @override
  ConsumerState<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends ConsumerState<ShopCard> {
  
  int _favNumber = 0;
  bool _favourite = false;
 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  Future<void> updateFavCount(String shopId, int newFavCount) async {
    try {
      DocumentReference shopRef = _firestore.collection('Shop').doc(shopId);

      await shopRef.update({'fav_count': newFavCount});

      print("fav_count updated successfully");
    } catch (e) {
      print("Error updating fav_count: $e");
      throw e; // or handle error appropriately
    }
  
  }
  Future<void> updateViewCount(String shopId, int newViewCount) async {
    try {
      DocumentReference shopRef = _firestore.collection('Shop').doc(shopId);

      // await shopRef.update({'views': shopRef.get()!.data as int + 1});

      print("Views count updated successfully");
    } catch (e) {
      print("Error updating Views count: $e");
      throw e; // or handle error appropriately
    }
  
  }
  // void _favInc() {
  //   updateFavCount(shopId, newFavCount)
  //   setState(() {
  //     _favNumber++;
  //   });
  // }
  // void _favDec() {
  //   setState(() {
  //     _favNumber--;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    //  widget.shop.fav_count = 10;
    // final locate = ref.watch(locationProvider);
    bool isActive = true;
    return Padding(
                      padding: EdgeInsets.only(
                          top: widget.mqh * 29 / 2340,
                          left: widget.mqw * 50 / 1080,
                          right: widget.mqw * 50 / 1080,
                          bottom: widget.mqh * 18 / 2340),
                      child: Container(
                        height: widget.mqh * 700 / 2340,
                        width: widget.mqw * 990 / 1080,
                        decoration: BoxDecoration(
                            boxShadow: const [
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
                            color: kWhite,
                            borderRadius: BorderRadius.circular(20.5)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: widget.mqh * 395 / 2340,
                              width: widget.mqw * 1000 / 1080,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20.5),
                                    topRight: Radius.circular(20.5)),
                                child: GestureDetector(
                                  onTap: () {
                                    updateViewCount(widget.shop.id, 10);
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                      maintainState: true,
                                      builder: (context) =>
                                          
                                           Product_Screen(shopId: widget.shop.id, startingYear: widget.shop.startingYear,),
                                    ));
                                  },
                                  child: Image.network(
                                    widget.shop.shopImageLink,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: widget.mqh * 28 / 2340),
                            Text(widget.shop.shop_name.toUpperCase(),
                                style: const TextStyle(
                                    color: kBlue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5)),
                            SizedBox(height: widget.mqh * 25 / 2340),
                             Text(widget.shop.address,
                                style: const TextStyle(
                                    color: kGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5)),
                            SizedBox(height: widget.mqh * 28 / 2340),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widget.mqw * 65 / 1080),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      _favourite
                                          ? GestureDetector(
                                              onTap: isActive? () {
                                                setState(() {
                                                  isActive = false;
                                                });
                                                updateFavCount(widget.shop.id, widget.shop.fav_count - 1);
                                                setState(() {
                                                  _favourite = false;
                                                  isActive=true;
                                                });
                                              }:null,
                                              child: const Icon(
                                                Icons.favorite,
                                                size: 22,
                                                color: kBlue,
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: isActive ? () {
                                                setState(() {
                                                  isActive = false;
                                                });
                                                 updateFavCount(widget.shop.id, widget.shop.fav_count + 1);
                                                setState(() {
                                                  _favourite = true;
                                                  isActive = true;
                                                });
                                              }:null,
                                              child: const Icon(
                                                Icons.favorite_border_outlined,
                                                size: 22,
                                                color: kBlue,
                                              ),
                                            ),
                                      SizedBox(width: widget.mqw * 7 / 1080),
                                       Text(
                                        widget.shop.fav_count.toString(),
                                        style: const TextStyle(
                                            color: kBlue,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // _launchMap();
                                          // String googleMapUrl =
                                              // "https://maps.google.com/?q=$lokation.lat_merchant,$lokation.long_merchant";

                                          // launch(googleMapUrl);
                                        },
                                        child: const Icon(
                                          Icons.location_on_outlined,
                                          size: 22,
                                          color: kBlue,
                                        ),
                                      ),
                                      SizedBox(width: widget.mqw * 1 / 1080),
                                      const Text(
                                        "100 m" ,
                                        style: const TextStyle(
                                            color: kBlue,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),

                                  widget.shop.isOpen? const Text('Open',
                                      style: TextStyle(
                                          color: kBlue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)):const Text('Closed',
                                      style: TextStyle(
                                          color: kRed,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                 ;
  }
}