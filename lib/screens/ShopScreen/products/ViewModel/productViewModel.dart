import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/utility/Widgets/animatedSearch/ViewModel/searchViewModel.dart';
import '../Model/productModel.dart';

class ProductFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ProductModel>> fetchProducts(String shopId, String searchText) {
    Query query = _firestore.collection('Shop').doc(shopId).collection('Product');

    if (searchText.isNotEmpty) {
      query = query
          .where('product_name', isGreaterThanOrEqualTo: searchText)
          .where('product_name', isLessThanOrEqualTo: searchText + '\uf8ff');
    }



    return query.snapshots().map((snapshot) {

      return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
    });
  }
}




// The repository provider does not need shopId or searchText as it doesn't depend on them
final productRepositoryProvider = Provider<ProductFirebase>((ref) {
  return ProductFirebase();
});

// The product list provider requires the shopId and searchText to fetch the products
final productListProvider = StreamProvider.family<List<ProductModel>, String>((ref, shopId) {
  final productRepository = ref.watch(productRepositoryProvider);
  final searchText = ref.watch(searchTextProvider);
  return productRepository.fetchProducts(shopId, searchText);
});

