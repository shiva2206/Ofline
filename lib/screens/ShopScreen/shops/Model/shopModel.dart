import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  final String id;
  final String shop_name;
  final String shopImageLink;
  final String address;
  final bool isOpen;
  final double latitude;
  final double longitude;
  final String startingYear;
  final String date;
  final int views;

  final int fav_count;
  final int live_view;
  final bool isActivated;
  final String shop_upi;
  final String shop_merchant_name;

  double distance = 0.0;
  String distanceText= "";

  ShopModel({
    required this.id,
    required this.shop_name,
    required this.shopImageLink,
    required this.address,
    required this.isOpen,
    required this.latitude,
    required this.longitude,
    required this.startingYear,
    required this.fav_count,
    required this.views,
    required this.isActivated,
    required this.live_view,
    required this.date,
    required this.shop_upi,
    required this.shop_merchant_name
  });

  factory ShopModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final geopoint = data['location'] as GeoPoint;
    return ShopModel(
      id: doc.id,
      shop_name: data['shop_name'],
      shopImageLink: data['shopImageLink'],
      address: data['address'],
      isOpen: data['isOpen'],
      startingYear: data['startingYear'],
      latitude: geopoint.latitude,
      longitude: geopoint.longitude,
      fav_count: data['fav_count'],
      views: data['views'],
      isActivated: data['isActivated'],
      live_view: data['live_view'],
      date: data['date'] ?? "",
      shop_upi: data['shop_upi'],
      shop_merchant_name: data['merchant_upi_name']
    );
  }
}

// class ShopSearchParams {
//   final String? searchQuery;
//   final double latitude;
//   final double longitude;

//   ShopSearchParams({
//     required this.searchQuery,
//     required this.latitude,
//     required this.longitude,
//   });
// }

