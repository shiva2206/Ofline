import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Model/CartModel.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Cartmodel> getFilteredCartStream(String customerId, String shopId) {
    final data1 = _firestore.collection('Cart').where('customer_id', isEqualTo : customerId)
        .where('shop_id', isEqualTo: shopId).snapshots().first;
    // print(data1);
    return _firestore
        .collection('Cart')
        .where('customer_id', isEqualTo : customerId)
        .where('shop_id', isEqualTo: shopId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Assuming there's only one cart per customer and shop combination
        return Cartmodel.fromFirestore(snapshot.docs.first);
      } else {
        // Handle the case when no cart exists
        throw Exception("No cart found for the given customer and shop ID");
      }
    });
  }
}

final cartServiceProvider = Provider((ref) => CartService());

final cartStreamProvider = StreamProvider.family<Cartmodel, Tuple2>((ref, ids) {
  final cartService = ref.read(cartServiceProvider);
  return cartService.getFilteredCartStream(ids.item1.id, ids.item2);
});