import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/ShopScreen/products/View/productView.dart';
import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';
import 'package:ofline_app/utility/Constants/color.dart';
import 'package:ofline_app/utility/Location/Model/locationModel.dart';
import 'package:ofline_app/utility/Location/ViewModel/locationViewModel.dart';
import 'package:intl/intl.dart' as intl;
class ShopCard extends ConsumerStatefulWidget {
  ShopCard({required super.key,required this.shop,required this.mqh,required this.mqw});
  final shop;
  final mqh,mqw;
  @override
  ConsumerState<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends ConsumerState<ShopCard> {
  

  int _favNumber = 0;
  bool _favourite = false;
 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> addShopToFavorites(String shopId) async {
  final firestore = FirebaseFirestore.instance;
  final customerId = FirebaseAuth.instance.currentUser!.uid;
  try {
    await firestore
        .collection('Customer')
        .doc(customerId)
        .collection('Favorite')
        .doc(shopId)
        .update({
      'fav_shop': shopId // Optional: Add other fields as necessary
    });
    print("Shop added to favorites!");
  } catch (e) {
    print("Error adding shop to favorites: $e");
  }
}
Future<void> removeShopFromFavorites(String shopId) async {
  final firestore = FirebaseFirestore.instance;
  final customerId = FirebaseAuth.instance.currentUser!.uid ;

  try {
    await firestore
        .collection('Customer')
        .doc(customerId)
        .collection('Favorites')
        .doc(shopId)
        .delete();
    print("Shop removed from favorites!");
  } catch (e) {
    print("Error removing shop from favorites: $e");
  }
}

  Future<void> updateFavCount(ShopModel shop, int newFavCount) async {
    try {
      DocumentReference shopRef = _firestore.collection('Shop').doc(shop.id);

      await shopRef.update({'fav_count': newFavCount});

      print("fav_count updated successfully");
    } catch (e) {
      print("Error updating fav_count: $e");
      throw e; // or handle error appropriately
    }
  
  }
  
  // Future<void> updateViewCount(ShopModel shop, int newViewCount) async {
  //   try {
  //     DocumentReference shopRef = _firestore.collection('Shop').doc(shop.id);

  //     await shopRef.update({'views': newViewCount});

  //     print("Views count updated successfully");
  //   } catch (e) {
  //     print("Error updating Views count: $e");
  //     throw e; // or handle error appropriately
  //   }
  
  // }
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


void storeDateInFirestore() async{
  // Get the current date
  DateTime now = DateTime.now();

  // Extract the date part (year, month, day) and create a new DateTime object
  DateTime onlyDate = DateTime(now.year, now.month, now.day);

  // Format the date as a string
  String formattedDate = intl.DateFormat('yyyy-MM-dd').format(onlyDate);

  // Store the formatted date string in Firestore
  if(widget.shop.date == null || widget.shop.date != formattedDate){
      await FirebaseFirestore.instance.collection('Shop').doc(widget.shop.id).update({
    'date': formattedDate,
    'views' :0
  }).then((value) {
    print("Date Added");
  }).catchError((error) {
    print("Failed to add date: $error");
  });
  }
  
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storeDateInFirestore();
  }
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
                                    // updateViewCount(widget.shop, 10);
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                      maintainState: true,
                                      builder: (context) =>
                                          
                                           Product_Screen(shop: widget.shop, startingYear: widget.shop.startingYear,),
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
                                                updateFavCount(widget.shop, widget.shop.fav_count - 1);
                                                removeShopFromFavorites(widget.shop.id);
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
                                              onTap: isActive ? () async{
                                                setState(() {
                                                  isActive = false;
                                                });
                                                 updateFavCount(widget.shop, widget.shop.fav_count + 1);
                                                  await addShopToFavorites(widget.shop.id);
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
                                       Text(
                                        widget.shop.distanceText ,
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