import 'package:flutter/material.dart';

import '../widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormFieldState> _nameFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _confirmPasswordFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _genderFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _birthDateFieldKey =
      GlobalKey<FormFieldState>();

  // Controllers للحقول النصية
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  // متغيرات إضافية
  String? selectedGender;
  DateTime? birthDate;
  bool hasChronicDiseases = false;
  bool hasDiabetes = false;
  bool hasHypertension = false;

  // دوال التحقق من صحة البيانات
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return "Please enter your full name";
    if (value.length < 3) return "Name must be at least 3 characters";
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Please enter your email";
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) return "Enter a valid email address";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Please enter your password";
    if (value.length < 8) return "Password must be at least 8 characters";
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Include at least one uppercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) return "Include at least one number";
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return "Please confirm your password";
    if (value != passwordController.text) return "Passwords do not match";
    return null;
  }

  String? _validateBirthDate(String? value) {
    if (value == null || value.isEmpty) return "Please select your birth date";
    return null;
  }

  // دالة اختيار تاريخ الميلاد
  Future<void> _pickBirthDate(BuildContext context) async {
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
      setState(() {
        birthDate = picked;
        birthDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  
  bool isAllFieldsValidate() {
    final isNameValid = _nameFieldKey.currentState?.validate() ?? false;
    final isEmailValid = _emailFieldKey.currentState?.validate() ?? false;
    final isPasswordValid = _passwordFieldKey.currentState?.validate() ?? false;
    final isConfirmPasswordValid = _confirmPasswordFieldKey.currentState?.validate() ?? false;
    final isGenderValid = _genderFieldKey.currentState?.validate() ?? false;
    final isBirthDate = _birthDateFieldKey.currentState?.validate() ?? false;
    return isNameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid && isGenderValid && isBirthDate;
  }

  // دالة إنشاء الحساب
  void _signUp() {
    if (isAllFieldsValidate()) {
      String chronicInfo = "Normal account";
      if (hasChronicDiseases) {
        List<String> diseases = [];
        if (hasDiabetes) diseases.add("Diabetes");
        if (hasHypertension) diseases.add("Hypertension");
        chronicInfo = diseases.isNotEmpty ? diseases.join(", ") : "Chronic diseases selected";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Account Created Successfully.\nName: ${nameController.text}\nEmail: ${emailController.text}\nGender: ${selectedGender ?? "Not specified"}\nBirth Date: ${birthDateController.text}\nChronic: $chronicInfo",
          ),
          backgroundColor: Colors.green,
        ),
      );

      // يمكنك إضافة عملية تسجيل الحساب أو الانتقال إلى شاشة أخرى هنا
    }else{
      //print('sfsdf                                            sdfsd');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Create Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    formFieldKey: _nameFieldKey,
                    hintText: "Full Name",
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    icon: Icons.person,
                    validator: _validateName,
                  ),
                ),
                const SizedBox(height: 15),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    formFieldKey: _emailFieldKey,
                    hintText: "Email Address",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.email,
                    validator: _validateEmail,
                  ),
                ),
                const SizedBox(height: 15),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    formFieldKey: _passwordFieldKey,
                    hintText: "Password",
                    controller: passwordController,
                    isPassword: true,
                    icon: Icons.lock,
                    validator: _validatePassword,
                  ),
                ),
                const SizedBox(height: 15),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    formFieldKey: _confirmPasswordFieldKey,
                    hintText: "Confirm Password",
                    controller: confirmPasswordController,
                    isPassword: true,
                    icon: Icons.lock_outline,
                    validator: _validateConfirmPassword,
                  ),
                ),
                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: selectedGender,
                  key: _genderFieldKey,
                  decoration: InputDecoration(
                    hintText: "Select Gender",
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(
                      Icons.transgender,
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Male",
                      child: Row(
                        children: [
                          Icon(Icons.male, color: Colors.blue),
                          SizedBox(width: 10),
                          Text("Male", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Female",
                      child: Row(
                        children: [
                          Icon(Icons.female, color: Colors.pink),
                          SizedBox(width: 10),
                          Text("Female", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Prefer not to say",
                      child: Row(
                        children: [
                          Icon(Icons.remove_circle, color: Colors.grey),
                          SizedBox(width: 10),
                          Text(
                            "Prefer not to say",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select your gender";
                    }
                    return null;
                  },
                  borderRadius: BorderRadius.circular(12),
                  elevation: 4,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  key: _birthDateFieldKey,
                  controller: birthDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Select Birth Date",
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onTap: () => _pickBirthDate(context),
                  validator: _validateBirthDate,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Do you suffer from chronic diseases?",
                      style: TextStyle(fontSize: 16),
                    ),
                    Switch(
                      value: hasChronicDiseases,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          hasChronicDiseases = value;
                          if (!value) {
                            hasDiabetes = false;
                            hasHypertension = false;
                          }
                        });
                      },
                    ),
                  ],
                ),
                if (hasChronicDiseases) ...[
                  CheckboxListTile(
                    title: const Text("Diabetes"),
                    value: hasDiabetes,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        hasDiabetes = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Hypertension"),
                    value: hasHypertension,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        hasHypertension = value ?? false;
                      });
                    },
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  //onPressed: () {},
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
