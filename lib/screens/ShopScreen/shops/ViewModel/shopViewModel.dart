import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:ofline_app/screens/ShopScreen/products/Model/productModel.dart';
import 'package:ofline_app/utility/Location/ViewModel/locationViewModel.dart';

import '../Model/shopModel.dart';



class ShopRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ShopModel>> fetchShopsAndProducts({String? searchQuery,double? latitude,double? longitude}) async* {
    await for (QuerySnapshot shopSnapshot in _firestore.collection('Shop').snapshots()) {
      List<ShopModel> shops = [];

      for (QueryDocumentSnapshot shopDoc in shopSnapshot.docs) {
        final shop = ShopModel.fromFirestore(shopDoc);
        if(latitude!=null && longitude!=null){
          shop.distance = calculateDistanceInKm(latitude, longitude, shop.latitude, shop.longitude);
          if(shop.distance>=50) continue;
          shop.distanceText = formatDistance(shop.distance);
        
        }
      
   
         if(!shop.isActivated) continue;
        if(shop.shop_name.toLowerCase().startsWith(searchQuery ?? "")){
          shops.add(shop);
          continue;
        }

        QuerySnapshot productSnapshot = await _firestore
            .collection('Shop')
            .doc(shop.id)
            .collection('Product')
            .get();

       for(QueryDocumentSnapshot prodDoc in productSnapshot.docs){
        final product = ProductModel.fromFirestore(prodDoc);
        if(product.product_name.toLowerCase().startsWith(searchQuery ??"")){
          shops.add(shop);
          break;
        }
       
       }

       
      }
       shops.sort((a, b) => a.distance.compareTo(b.distance));
      yield shops;
    }
  }
 
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
      print(shop);
      print(doc.id);

      print(!shop.shop_name.toLowerCase().startsWith(searchQuery!.toLowerCase() ?? ""));
      if(!shop.isActivated) continue;
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



  double calculateDistanceInKm(
      double lat1, double lon1, double lat2, double lon2) {
    const double p = 0.017453292519943295;

    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;

    double distanceInKm = 12742 * asin(sqrt(a));
    return double.parse(distanceInKm.toStringAsFixed(1));
  }

  String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).round()} m';
    } else {
      return '${distanceInKm.round()} km';
    }
  }

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepository();
});

final shopListProvider = StreamProvider.family<List<ShopModel>, String?>((ref, searchQuery) {
  final shopRepository = ref.watch(shopRepositoryProvider);
  final userLocation = ref.watch(locationProvider);

  return shopRepository.fetchShopsAndProducts(searchQuery: searchQuery,latitude: userLocation?.latitude,longitude:userLocation?.longitude);
});