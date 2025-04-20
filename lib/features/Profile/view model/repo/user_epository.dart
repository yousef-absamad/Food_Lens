import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_lens/features/Profile/model/user_model.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData({
    required String fullName,
    required String email,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userModel = UserModel(
        uid: user.uid,
        fullName: fullName,
        email: email,
        photoUrl: user.photoURL,
      );

      await _firestore.collection("users").doc(user.uid).set(userModel.toMap());
    }
  }

  Future<void> saveAdditionalUserData(UserModel userModel) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection("users").doc(user.uid).update({
          "gender": userModel.gender,
          "birthDate": userModel.birthDate?.toIso8601String(),
          "hasDiabetes": userModel.hasDiabetes,
          "hasHypertension": userModel.hasHypertension,
          "weight": userModel.weight,
          "height": userModel.height,
        });
      } catch (e) {
        throw Exception("An error occurred while saving data.");
      }
    }
  }

  Future<UserModel?> getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final DocumentSnapshot doc =
            await _firestore.collection("users").doc(user.uid).get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          return UserModel.fromMap(data);
        } else {
          return null;
        }
      } catch (e) {
        throw Exception("An error occurred while fetching user data: $e");
      }
    }
    return null;
  }

  Future<bool> hasChronicDiseases() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final DocumentSnapshot doc = await _firestore.collection("users").doc(user.uid).get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          final userModel = UserModel.fromMap(data);

          return userModel.hasDiabetes || userModel.hasHypertension;
        } else {
          return false; 
        }
      } catch (e) {
        throw Exception(
          "An error occurred while checking chronic diseases: $e",
        );
      }
    }
    return false; 
  }
}
