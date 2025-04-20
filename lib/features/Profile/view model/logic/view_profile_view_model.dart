import 'package:flutter/material.dart';
//import 'package:food_lens/features/Profile/view%20model/repo/user_epository.dart';

import '../../model/user_model.dart';

enum ProfileState { initial, loading, success, error }
class ViewProfileViewModel extends ChangeNotifier {
  //final UserRepository _userRepository = UserRepository();

  ProfileState state = ProfileState.initial;
  String? errorMessage;
  String? photoURL;
  DateTime? birthDate;
  bool hasDiabetes = false;
  bool hasHypertension = false;


  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();


  void initializeWithUser(UserModel? userModel) {
    if (userModel == null) {
      state = ProfileState.error;
      errorMessage = "No user data provided.";
      notifyListeners();
      return;
    }

    _populateControllers(userModel);
    state = ProfileState.success;
    notifyListeners();
  }

  void _populateControllers(UserModel user) {
    fullNameController.text = user.fullName ?? '';
    genderController.text = user.gender ?? '';
    ageController.text = user.age?.toString() ?? '';
    birthDate = user.birthDate;
    birthDateController.text = birthDate != null
        ? "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}"
        : "";
    heightController.text = user.height ?? '';
    weightController.text = user.weight ?? '';
    hasDiabetes = user.hasDiabetes;
    hasHypertension = user.hasHypertension;
    photoURL = user.photoUrl;
  }
}




  // Future<void> loadUserData() async {
  //   try {
  //     state = ProfileState.loading;
  //     notifyListeners();

  //     final userData = await _userRepository.getUserData();

  //     if (userData != null) {
  //       fullNameController.text = userData.fullName ?? '';
  //       genderController.text = userData.gender ?? '';
  //       ageController.text = userData.age?.toString() ?? '';
  //       birthDate = userData.birthDate;
  //       birthDateController.text = birthDate != null
  //           ? "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}"
  //           : "";
  //       heightController.text = userData.height ?? '';
  //       weightController.text = userData.weight ?? '';
  //       hasDiabetes = userData.hasDiabetes;
  //       hasHypertension = userData.hasHypertension;
  //       photoURL = userData.photoUrl;

  //       state = ProfileState.success;
  //     } else {
  //       state = ProfileState.error;
  //       errorMessage = "No user data found.";
  //     }
  //   } catch (e) {
  //     state = ProfileState.error;
  //     errorMessage = "Failed to load data. Please check your connection.";
  //   }

  //   notifyListeners();
  // }

