// //screen2
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:location/location.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';



  // Future<void> _fetchShops({String? searchQuery}) async {
  //   QuerySnapshot snapshot =
  //       await FirebaseFirestore.instance.collection('shops').get();

  //   List<Map<String, dynamic>> tempShops = [];

  //   for (DocumentSnapshot doc in snapshot.docs) {
  //     GeoPoint geoPoint = doc['location'];
  //     double latitude = geoPoint.latitude;
  //     double longitude = geoPoint.longitude;
  //     double distanceInKm =
  //         calculateDistanceInKm(latitude!, longitude!, latitude, longitude);
  //     String distance = formatDistance(distanceInKm);

  //     QuerySnapshot productsSnapshot =
  //         await doc.reference.collection('products').get();

  //     bool hasMatchingProduct = false;
  //     for (var productDoc in productsSnapshot.docs) {
  //       if (searchQuery != null &&
  //           productDoc['name']
  //               .toLowerCase()
  //               .startsWith(searchQuery.toLowerCase())) {
  //         hasMatchingProduct = true;
  //         break;
  //       }
  //     }

  //     if (hasMatchingProduct ||
  //         (searchQuery != null &&
  //             doc['name']
  //                 .toLowerCase()
  //                 .startsWith(searchQuery.toLowerCase()))) {
  //       tempShops.add({
  //         'name': doc['name'],
  //         'latitude': latitude,
  //         'longitude': longitude,
  //         'distanceInKm': distanceInKm,
  //         'distance': distance,
  //       });
  //     }
  //   }

  //   tempShops.sort((a, b) => a['distanceInKm'].compareTo(b['distanceInKm']));

  //   // setState(() {
  //   //   shops = tempShops;
  //   // });
  // }

//   double calculateDistanceInKm(
//       double lat1, double lon1, double lat2, double lon2) {
//     const double p = 0.017453292519943295;

//     final a = 0.5 -
//         cos((lat2 - lat1) * p) / 2 +
//         cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;

//     double distanceInKm = 12742 * asin(sqrt(a));
//     return double.parse(distanceInKm.toStringAsFixed(1));
//   }

//   String formatDistance(double distanceInKm) {
//     if (distanceInKm < 1) {
//       return '${(distanceInKm * 1000).round()} m';
//     } else {
//       return '${distanceInKm.round()} km';
//     }
//   }

//   void _openMaps(double latitude, double longitude) async {
//     String url =
//         'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
//     if (await canLaunchUrlString(url)) {
//       await launchUrlString(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   Future<LocationData?> getCurrentLocation() async {
//     Location location = Location();

//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//     LocationData locationData;

//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return null;
//       }
//     }

//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return null;
//       }
//     }

//     locationData = await location.getLocation();
//     // setState(() {
//     //   _latitude = locationData.latitude;
//     //   _longitude = locationData.longitude;
//     // });

//     return locationData;
//   }

// final locationProvider = FutureProvider<LocationData?>((ref) async {
//   return await getCurrentLocation();
// });


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

// Define a data class to hold location data
class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({required this.latitude, required this.longitude});
}
