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
  final int views;
  final int fav_count;
  final bool isActivated;

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
    required this.isActivated
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
      isActivated: data['isActivated']
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


