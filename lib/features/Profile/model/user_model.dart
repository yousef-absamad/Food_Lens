class UserModel {
  final String? uid;
  final String? fullName;
  final String? email;
  final String? gender;
  final DateTime? birthDate;
  final String? weight;
  final String? height;
  final bool hasDiabetes;
  final bool hasHypertension;
  final String? photoUrl;

  int? get age {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int calculatedAge = now.year - birthDate!.year;
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  bool get hasChronicDiseases {
    return hasDiabetes || hasHypertension;
  }

  UserModel({
    this.uid,
    this.fullName,
    this.email,
    this.photoUrl,
    this.gender,
    this.birthDate,
    this.weight,
    this.height,
    this.hasDiabetes = false,
    this.hasHypertension = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'],
      birthDate:
          map['birthDate'] != null ? DateTime.tryParse(map['birthDate']) : null,
      weight: map['weight'],
      height: map['height'],
      hasDiabetes: map['hasDiabetes'] ?? false,
      hasHypertension: map['hasHypertension'] ?? false,
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'weight': weight,
      'height': height,
      'hasDiabetes': hasDiabetes,
      'hasHypertension': hasHypertension,
      'photoUrl': photoUrl,
    };
  }
}
