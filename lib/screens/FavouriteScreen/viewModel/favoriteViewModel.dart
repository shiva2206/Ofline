import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/ShopScreen/shops/Model/shopModel.dart';

class ShopRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<ShopModel>> fetchFavorites() {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('Customer')
        .doc(user.uid)
        .collection('Favorite')
        .snapshots()
        .asyncMap((snapshot) async {
      final List<ShopModel> favoriteShops = [];

      for (var doc in snapshot.docs) {
        final shopId = doc['fav_shop'];
        final shopDoc = await _firestore.collection('Shop').doc(shopId).get();
        if (shopDoc.exists) {
          favoriteShops.add(ShopModel.fromFirestore(shopDoc));
        }
      }

      return favoriteShops;
    });
  }
}


final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepository();
});

final favoritesStreamProvider = StreamProvider<List<ShopModel>>((ref) {
  final shopRepository = ref.watch(shopRepositoryProvider);
  return shopRepository.fetchFavorites();
});