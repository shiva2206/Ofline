import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/ShopScreen/cart/Model/CartModel.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Cartmodel?> getFilteredCartStream(String shopId, String customerId) {
    return _firestore
        .collection('Cart')
        .where('customer_id', isEqualTo: customerId)
        .where('shop_id', isEqualTo: shopId)
        .snapshots()
        .map((snapshot) {
          print(snapshot.docs);
      if (snapshot.docs.isNotEmpty) {
        try {
          final data = Cartmodel.fromFirestore(snapshot.docs.first);
          print(data);
        } catch (e) {
          print("Error parsing cart data: $e");
          return null;
        }
      } else {
        print("No cart items found for the given customer and shop.");
        return null;
      }
    })
        .handleError((error) {
      print("Error fetching cart items: $error");
      return null;
    }).distinct();
  }
}

final cartServiceProvider = Provider((ref) => CartService());

final cartStreamProvider = StreamProvider.family<Cartmodel?, Tuple2>((ref, ids) {
  if (ids.shopId.isNotEmpty && ids.customerId.isNotEmpty) {
    final cartService = ref.watch(cartServiceProvider);
    return cartService.getFilteredCartStream(ids.shopId, ids.customerId);
  } else {
    return Stream.value(null);
  }
});