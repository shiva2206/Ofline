import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategoryModel {
  final String id;
  final String name;

  SubCategoryModel({required this.id, required this.name});

  factory SubCategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubCategoryModel(id: doc.id, name: data['sub_category_name']);
  }
}