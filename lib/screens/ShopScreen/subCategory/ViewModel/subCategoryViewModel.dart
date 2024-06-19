import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ofline_app/screens/ShopScreen/subCategory/Model/subCategoryModel.dart';



class SubcategoryFirebase{
  final subCategoryProvider = StreamProvider.family<List<SubCategoryModel>, String>((ref, shopId){
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore.collection('Shop').doc(shopId).collection('SubCategory').snapshots().map((snapshot){
      return snapshot.docs.map((doc)=> SubCategoryModel.fromFirestore(doc)).toList();
    });
  });
}