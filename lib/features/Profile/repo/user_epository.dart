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
      await _firestore.collection("users").doc(user.uid).set({
        "fullName": fullName,
        "email": email,
        "uid": user.uid,
      });
    }
  }

  Future<void> saveAdditionalUserData({
    String? gender,
    DateTime? birthDate,
    String? weight,
    String? height,
    bool hasDiabetes = false,
    bool hasHypertension = false,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection("users").doc(user.uid).update({
          "gender": gender,
          "birthDate": birthDate?.toIso8601String(),
          "hasDiabetes": hasDiabetes,
          "hasHypertension": hasHypertension,
          "weight": weight,
          "height": height,
        });
      } catch (e) {
        throw Exception("An error occurred while saving data.");
      }
    }
  }
}
