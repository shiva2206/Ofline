import 'package:cloud_firestore/cloud_firestore.dart';


class ProductModel {
  final String id;
  final String product_name;
  final String product_image;
  final Map<String, dynamic> sizeVariants;
  final bool inStock;
  final bool isVeg;
  final String sub_category;

  ProductModel(
      {required this.id,
      required this.product_name,
      required this.product_image,
      required this.sizeVariants,
      required this.inStock,
      required this.isVeg,
      required this.sub_category});

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
        id: doc.id,
        product_name: data['product_name'],
        product_image: data['productImageLink'],
        sizeVariants: data['sizeVariant'] ?? {"Regular": 100} as Map<String, dynamic>,
        inStock: data['inStock'],
        isVeg: data['isVeg'],
        sub_category: data['sub_category']
    );
  }

  factory ProductModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map <String, dynamic>;
    return ProductModel(
        id: doc.id,
        product_name: data['product_name'],
        product_image: data['productImageLink'],
        sizeVariants: data['sizeVariant'],
        inStock: data['inStock'],
        isVeg: data['isVeg'],
        sub_category: data['sub_category']);
  }
}