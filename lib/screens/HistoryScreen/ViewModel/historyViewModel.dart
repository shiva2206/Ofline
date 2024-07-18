import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Model/historyModel.dart';


final customerHistoryStreamProvider = StreamProvider.autoDispose.family<List<History>, String>((ref, customerId) {
  return FirebaseFirestore.instance
      .collection('History')
      .where('customer_id', isEqualTo: customerId)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => History.fromFirestore(doc)).toList());
});