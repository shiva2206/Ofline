import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define a provider that takes a shop ID as a parameter.
final isOpenProvider = StateNotifierProvider.family<IsShopOpenNotifier, bool, String>((ref, shopId) {
  return IsShopOpenNotifier(shopId);
});

class IsShopOpenNotifier extends StateNotifier<bool> {
  final String shopId;

  // The constructor now takes a shop ID.
  IsShopOpenNotifier(this.shopId) : super(false) {
    _isShopOpen();
  }

  void _isShopOpen() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Shop').doc(shopId).get();
    if (doc.exists) {
      state = doc['isOpen'] as bool;
    }
  }

  void updateIsShopOpen(bool newValue) async {
    await FirebaseFirestore.instance
        .collection('Shop')
        .doc(shopId)
        .set({'isOpen': newValue}, SetOptions(merge: true));
    state = newValue;
  }
}
