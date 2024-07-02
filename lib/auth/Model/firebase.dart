import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {
  Future addUser(String userId, Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance.collection("Customer").doc(userId).set(userInfoMap);
  }
}