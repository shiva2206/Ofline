import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {
  Future addUser(String userId, Map<String, dynamic> userInfoMap){
    return FirebaseFirestore.instance.collection("Customer").doc(userId).update(userInfoMap);
  }
}