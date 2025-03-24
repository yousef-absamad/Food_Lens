import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData({
    required String fullName,
    required String email,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      print(
        "Saving to Firestore: Name = $fullName, Email = $email, UID = ${user.uid}",
      );

      await _firestore.collection("users").doc(user.uid).set({
        "fullName": fullName,
        "email": email,
        "uid": user.uid,
      });
    }
  }

}
