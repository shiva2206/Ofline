import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ofline_app/screens/ShopScreen/products/View/productView.dart';
import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';
import 'package:ofline_app/utility/Constants/color.dart';
import 'package:ofline_app/utility/Location/Model/locationModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utility/Location/ViewModel/locationViewModel.dart';

class ShopCard extends ConsumerStatefulWidget {
  ShopCard({
    required super.key,
    required this.shop,
    required this.mqh,
    required this.mqw,
    required this.isFavourite,
  });

  final ShopModel shop;
  final double mqh, mqw;
  final bool isFavourite;

  @override
  ConsumerState<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends ConsumerState<ShopCard> {
  bool _favourite = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _favourite = widget.isFavourite; // Initialize favorite state from widget prop
  }

  Future<void> openGoogleMapsDirections(LatLng start, LatLng end) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&travelmode=driving';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Future<void> addShopToFavorites(String shopId) async {
    try {
      final customerId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('Customer').doc(customerId).update({
        'fav_shop': FieldValue.arrayUnion([shopId])
      });
      print("Shop added to favorites!");
      setState(() {
        _favourite = true; // Update UI state
      });
    } catch (e) {
      print("Error adding shop to favorites: $e");
    }
  }

  Future<void> removeShopFromFavorites(String shopId) async {
    try {
      final customerId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('Customer').doc(customerId).update({
        'fav_shop': FieldValue.arrayRemove([shopId])
      });
      print("Shop removed from favorites!");
      setState(() {
        _favourite = false;
      });
    } catch (e) {
      print("Error removing shop from favorites: $e");
    }
  }

  Future<void> updateFavCount(ShopModel shop, int change) async {
    try {
      final shopRef = FirebaseFirestore.instance.collection('Shop').doc(shop.id);
      await shopRef.update({'fav_count': FieldValue.increment(change)});
      print("fav_count updated successfully");
    } catch (e) {
      print("Error updating fav_count: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);
    return Padding(
      padding: EdgeInsets.only(
        top: widget.mqh * 29 / 2340,
        left: widget.mqw * 50 / 1080,
        right: widget.mqw * 50 / 1080,
        bottom: widget.mqh * 18 / 2340,
      ),
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
          borderRadius: BorderRadius.circular(20.5),
        ),
        child: Column(
          children: [
            SizedBox(
              height: widget.mqh * 395 / 2340,
              width: widget.mqw * 1000 / 1080,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.5),
                  topRight: Radius.circular(20.5),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        maintainState: true,
                        builder: (context) =>
                            Product_Screen(shop: widget.shop, startingYear: widget.shop.startingYear),
                      ),
                    );
                  },
                  child: Image.network(
                    widget.shop.shopImageLink,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: widget.mqh * 28 / 2340),
            Text(
              widget.shop.shop_name.toUpperCase(),
              style: const TextStyle(
                color: kBlue,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: widget.mqh * 25 / 2340),
            Text(
              widget.shop.address,
              style: const TextStyle(
                color: kGrey,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: widget.mqh * 28 / 2340),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.mqw * 65 / 1080),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _isProcessing
                            ? null
                            : () async {
                          setState(() {
                            _isProcessing = true;
                          });
                          if (_favourite) {
                            await removeShopFromFavorites(widget.shop.id);
                            await updateFavCount(widget.shop, -1);
                          } else {
                            await addShopToFavorites(widget.shop.id);
                            await updateFavCount(widget.shop, 1);
                          }
                          setState(() {
                            _isProcessing = false;
                          });
                        },
                        child: Icon(
                          _favourite ? Icons.favorite : Icons.favorite_border_outlined,
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      openGoogleMapsDirections(LatLng(location!.latitude, location.longitude), LatLng(widget.shop.latitude, widget.shop.longitude));
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 22,
                          color: kBlue,
                        ),
                        SizedBox(width: widget.mqw * 1 / 1080),
                        Text(
                          widget.shop.distanceText,
                          style: const TextStyle(
                            color: kBlue,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.shop.isOpen ? 'Open' : 'Closed',
                    style: TextStyle(
                      color: widget.shop.isOpen ? kBlue : kRed,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
