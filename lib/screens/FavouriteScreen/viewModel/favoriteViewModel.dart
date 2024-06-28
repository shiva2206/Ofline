import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';

class ShopRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<HashSet<String>> fetchFavoriteShopIds() {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value(HashSet<String>());
    }

    return _firestore
        .collection('Customer')
        .doc(user.uid)
        .collection('Favourite')
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

  Stream<List<ShopModel>> fetchFavoriteShops() {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('Customer')
        .doc(user.uid)
        .collection('Favourite')
        .doc(user.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      final List<ShopModel> favoriteShops = [];

      if (snapshot.exists && snapshot.data() != null) {
        final List<dynamic> favShopIds = snapshot.data()!['fav_shop'] ?? [];
        for (var shopId in favShopIds) {
          final shopDoc = await _firestore.collection('Shop').doc(shopId).get();
          if (shopDoc.exists) {
            favoriteShops.add(ShopModel.fromFirestore(shopDoc));
          }
        }
      }

      return favoriteShops;
    });
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
  return shopRepository.fetchFavoriteShops();
});
