import'dart:collection';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';
import 'package:ofline_app/utility/Location/ViewModel/locationViewModel.dart';

class ShopRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<HashSet<String>> fetchFavoriteShopIds() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Stream.value(HashSet<String>());
    }

    return FirebaseFirestore.instance
        .collection('Customer')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      final HashSet<String> favoriteShopIds = HashSet<String>();
      if (snapshot.exists && snapshot.data() != null) {
        final List<dynamic> favShops = snapshot.data()!['fav_shop'] ?? [];
        for (var shopId in favShops) {
          if (shopId is String) {
            favoriteShopIds.add(shopId);
          }
        }
      }
      return favoriteShopIds;
    });
  }

  Stream<List<ShopModel>> fetchFavouriteShops(
      {double? latitude, double? longitude}) {
    final user = _auth.currentUser;
    return FirebaseFirestore.instance
        .collection('Customer')
        .doc(user?.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      final List<ShopModel> favoriteShops = [];

      if (snapshot.exists && snapshot.data() != null) {
        final List<dynamic> favShopIds = snapshot.data()!['fav_shop'] ?? [];

        for (var shopId in favShopIds) {
          final shopDoc = await FirebaseFirestore.instance.collection('Shop').doc(shopId).get();
          if (shopDoc.exists) {
            final shop = ShopModel.fromFirestore(shopDoc);
            if(latitude!=null && longitude!=null){
              shop.distance = calculateDistanceInKm(latitude, longitude, shop.latitude, shop.longitude);
              shop.distanceText = formatDistance(shop.distance);
            }
            favoriteShops.add(shop);
          }
        }
      }
      favoriteShops.sort((a, b) => a.distance.compareTo(b.distance));
      return favoriteShops;
    });
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
}
final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepository();
});

final favoriteShopIdsProvider = StreamProvider<HashSet<String>>((ref) {
  final shopRepository = ref.watch(shopRepositoryProvider);
  return shopRepository.fetchFavoriteShopIds();
});

final favoriteShopsProvider = StreamProvider<List<ShopModel>>((ref) {
  final shopRepository = ref.watch(shopRepositoryProvider);
  final userLocation = ref.watch(locationProvider);
  return shopRepository.fetchFavouriteShops(latitude: userLocation?.latitude,longitude:userLocation?.longitude);
  return shopRepository.fetchFavouriteShops();
});
