import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:ofline_app/utility/Location/Model/locationModel.dart';
import 'package:ofline_app/utility/Location/ViewModel/locationViewModel.dart';

import '../Model/shopModel.dart';



class ShopRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ShopModel>> fetchShops({String? searchQuery}) {
  Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('Shop');
  
      // final container = ProviderContainer();
  // Filter shops by name if a search query is provided
  if (searchQuery != null && searchQuery.isNotEmpty) {
    query = query.where('shop_name', isGreaterThanOrEqualTo: searchQuery)
                 .where('shop_name', isLessThanOrEqualTo: searchQuery + '\uf8ff');
  }

  return query.snapshots().asyncMap((snapshot) async {
    final List<ShopModel> shops = [];

    // Process each shop document
    for (var doc in snapshot.docs) {
      var shop = ShopModel.fromFirestore(doc);
      bool shouldAddShop = false;
      
      // Check if shop name starts with the search query
      print(shop.shop_name);

      print(!shop.shop_name.toLowerCase().startsWith(searchQuery!.toLowerCase() ?? ""));
      if (searchQuery != null && !shop.shop_name.toLowerCase().startsWith(searchQuery.toLowerCase())) {
        // Fetch products if the shop name does not match
        
        final productsSnapshot = await doc.reference.collection('Product').get();

        // Check if any product matches the search query
        for (var productDoc in productsSnapshot.docs) {
          if ((productDoc['product_name'] as String).toLowerCase().startsWith(searchQuery.toLowerCase())) {
            shouldAddShop = true;
            break;
          }
        }
      } else {
        shouldAddShop = true; // Shop name matches the search query
      }
      // final locationData = container.read(locationProvider);
  
      // double latitude = shop.latitude;
      //   double longitude = shop.longitude;
      //   double distance =
      //       _calculateDistanceInKm(locationData.latitude!, locationData.longitude!, latitude, longitude);
      //   shop.distance = distance;
      //   shop.distanceText = _formatDistance(distance);

      if (shouldAddShop) {
        
        // shop.distance = calculateDistanceInKm(locd!.latitude!, locd!.longitude!, shop.latitude, shop.longitude);
        // // shop.distanceText = formatDistance(shop.distance);
        // print(locd);
        shops.add(shop);
      }
    }
    shops.sort((a, b) => a.distance.compareTo(b.distance));
    return shops;
  });
}

}
final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepository();
});

final shopListProvider = StreamProvider.family<List<ShopModel>, String?>((ref, searchQuery) {
  final shopRepository = ref.watch(shopRepositoryProvider);
  return shopRepository.fetchShops(searchQuery: searchQuery);
});

  // Future<List<ShopModel>> _fetchShops({String? searchQuery}) async {

  //     final container = ProviderContainer();
  //      List<ShopModel> tempShops = [];
  //     try {
  //       // Read the current state from locationProvider
  //       final locationData = container.read(locationProvider);

  //       if (locationData != null) {
  //         print('Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}');

  //         QuerySnapshot snapshot =
  //             await FirebaseFirestore.instance.collection('Shop').get();

         

  //         for (DocumentSnapshot doc in snapshot.docs) {
  //           var shop = ShopModel.fromFirestore(doc);
            

            


  //           double latitude = shop.latitude;
  //           double longitude = shop.longitude;
  //           double distance =
  //               _calculateDistanceInKm(locationData.latitude!, locationData.longitude!, latitude, longitude);
  //           shop.distance = distance;
  //           shop.distanceText = _formatDistance(distance);

  //           QuerySnapshot productsSnapshot =
  //               await doc.reference.collection('Product').get();

  //           bool hasMatchingProduct = false;
  //           for (var productDoc in productsSnapshot.docs) {
  //             if (searchQuery != null &&
  //                 productDoc['name']
  //                     .toLowerCase()
  //                     .startsWith(searchQuery.toLowerCase())) {
  //               hasMatchingProduct = true;
  //               break;
  //             }
  //           }

  //           if (hasMatchingProduct ||
  //               (searchQuery != null &&
  //                   doc['name']
  //                       .toLowerCase()
  //                       .startsWith(searchQuery.toLowerCase()))) {
  //             tempShops.add(shop);
  //           }
  //         }

  //         tempShops.sort((a, b) => a.distance.compareTo(b.distance));
          
  //         // setState(() {
  //         //   shops = tempShops;
  //         // });
  //       } else {
  //         print('Location data is not available.');
  //       }
  //     } finally {
  //       // Dispose of the container to avoid memory leaks
  //       container.dispose();
  //     }
    
  //     return tempShops;
  
  // }


  
  // double _calculateDistanceInKm(
  //     double lat1, double lon1, double lat2, double lon2) {
  //   const double p = 0.017453292519943295;

  //   final a = 0.5 -
  //       cos((lat2 - lat1) * p) / 2 +
  //       cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;

  //   return 12742 * asin(sqrt(a));
  // }

  // String _formatDistance(double distanceInKm) {
  //   if (distanceInKm < 1) {
  //     return '${(distanceInKm * 1000).round()} m';
  //   } else {
  //     return '${distanceInKm.round()} km';
  //   }
  // }
