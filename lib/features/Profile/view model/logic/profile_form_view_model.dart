import 'package:flutter/material.dart';
import 'package:food_lens/features/Profile/model/user_model.dart';
import 'package:food_lens/features/Profile/view%20model/repo/user_epository.dart';
import 'package:food_lens/features/home/home.dart';

enum ProfileMode { complete, update }

enum ProfileLoadStatus { initial, loading, success, error }

enum ProfileSaveOrUpdateStatus { initial, loading, success, error }

class ProfileFormViewModel with ChangeNotifier {
  bool _isDisposed = false;
  final UserModel? userModel;

  final UserRepository _userRepository;
  final ProfileMode profileMode;

  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  final GlobalKey<FormFieldState> birthDateKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> genderKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> heightKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> weightKey = GlobalKey<FormFieldState>();

  String? selectedGender;
  DateTime? birthDate;
  bool hasDiabetes = false;
  bool hasHypertension = false;
  ProfileLoadStatus loadStatus = ProfileLoadStatus.initial;
  ProfileSaveOrUpdateStatus saveOrUpdateStatus =
      ProfileSaveOrUpdateStatus.initial;
  String? errorMessage;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  ProfileFormViewModel(
    this._userRepository,
    this.profileMode, {
    this.userModel,
  }) {
    if (profileMode == ProfileMode.update && userModel != null) {
      _fillFieldsFromUser(userModel!);
      loadStatus = ProfileLoadStatus.success;
      notifyListeners();
    }
  }

  void _fillFieldsFromUser(UserModel userData) {
    selectedGender =
        (userData.gender == 'Male' || userData.gender == 'Female')
            ? userData.gender
            : null;
    birthDate = userData.birthDate;
    birthDateController.text =
        birthDate != null
            ? "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}"
            : "";
    heightController.text = userData.height ?? "";
    weightController.text = userData.weight ?? "";
    hasDiabetes = userData.hasDiabetes;
    hasHypertension = userData.hasHypertension;
    _initTextControllersListeners();
  }

  void _initTextControllersListeners() {
    heightController.addListener(() {
      notifyListeners();
    });
    weightController.addListener(() {
      notifyListeners();
    });
  }

  bool validateForm() {
    bool isValid = true;

    if (!(birthDateKey.currentState?.validate() ?? false)) isValid = false;
    if (!(heightKey.currentState?.validate() ?? false)) isValid = false;
    if (!(weightKey.currentState?.validate() ?? false)) isValid = false;
    if (!(genderKey.currentState?.validate() ?? false)) isValid = false;

    return isValid;
  }

  String? validateGender(String? value) {
    if (value == null || value.isEmpty) return "Please select your gender";
    return null;
  }

  String? validateHeight(String? value) {
    if (value != null && value.isNotEmpty) {
      final height = double.tryParse(value);
      if (height == null || height <= 0) return "Please enter a valid height";
    }
    return null;
  }

  String? validateWeight(String? value) {
    if (value != null && value.isNotEmpty) {
      final weight = double.tryParse(value);
      if (weight == null || weight <= 0) return "Please enter a valid weight";
    }
    return null;
  }

  String? validateBirthDate(String? value) {
    if (value == null || value.isEmpty) return "Please select your birth date";
    return null;
  }

  Future<void> pickBirthDate(BuildContext context) async {
    DateTime initialDate = DateTime(2000);
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      birthDate = picked;
      birthDateController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  bool get hasChanges {
    return selectedGender != userModel?.gender ||
        birthDate != userModel?.birthDate ||
        hasDiabetes != userModel?.hasDiabetes ||
        hasHypertension != userModel?.hasHypertension ||
        weightController.text != userModel?.weight ||
        heightController.text != userModel?.height;
  }

  void _navigateAfterSave(BuildContext context) {
    if (profileMode == ProfileMode.complete) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pop(context, true);
    }
  }

  Future<void> saveOrUpdateData(BuildContext context) async {
    if (!validateForm()) return;

    try {
      saveOrUpdateStatus = ProfileSaveOrUpdateStatus.loading;
      notifyListeners();

      final userModel = UserModel(
        gender: selectedGender,
        birthDate: birthDate,
        hasDiabetes: hasDiabetes,
        hasHypertension: hasHypertension,
        weight: weightController.text,
        height: heightController.text,
      );

      await _userRepository.saveAdditionalUserData(userModel);
      saveOrUpdateStatus = ProfileSaveOrUpdateStatus.success;
      notifyListeners();

      _navigateAfterSave(context);
    } catch (e) {
      saveOrUpdateStatus = ProfileSaveOrUpdateStatus.error;
      errorMessage = ('Failed to save profile data: ${e.toString()}');
      notifyListeners();
    }
  }
}
