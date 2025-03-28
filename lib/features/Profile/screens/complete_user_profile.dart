import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_lens/core/cutom_text_field.dart';
import 'package:food_lens/features/Profile/repo/user_epository.dart';
import 'package:food_lens/features/home/home.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
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

  bool validateForm() {
    bool isValid = true;

    if (!(birthDateKey.currentState?.validate() ?? false)) {
      isValid = false;
    }
    if (!(heightKey.currentState?.validate() ?? false)) {
      isValid = false;
    }
    if (!(weightKey.currentState?.validate() ?? false)) {
      isValid = false;
    }
    if (!(genderKey.currentState?.validate() ?? false)) {
      isValid = false;
    }

    return isValid;
  }

  void _saveData() {
    if (validateForm()) {
      UserRepository userRepository = UserRepository();
      userRepository.saveAdditionalUserData(
        gender: selectedGender,
        birthDate: birthDate,
        hasDiabetes: hasDiabetes,
        hasHypertension: hasHypertension,
        weight: weightController.text,
        height: heightController.text,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Data saved'), backgroundColor: Colors.green));
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false,
      );
    }
  }

  String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return "Please select your gender";
    }
    return null;
  }

  String? validateHeight(String? value) {
    if (value != null && value.isNotEmpty) {
      final height = double.tryParse(value);
      if (height == null || height <= 0) {
        return "Please enter a valid height";
      }
    }
    return null;
  }

  String? validateWeight(String? value) {
    if (value != null && value.isNotEmpty) {
      final weight = double.tryParse(value);
      if (weight == null || weight <= 0) {
        return "Please enter a valid weight";
      }
    }
    return null;
  }

  String? validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Please select your birth date";
    }
    return null;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "complete your personal information",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 250,
                child: SvgPicture.asset('assets/image/CompleteProfile.svg'),
              ),
              Text(
                'Gender',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: selectedGender,
                key: genderKey,
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
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green),
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
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                validator: validateGender,
                borderRadius: BorderRadius.circular(12),
                elevation: 4,
              ),
              SizedBox(height: 10),
              CustomTextField(
                hintText: 'Select Birth Date',
                controller: birthDateController,
                icon: Icons.calendar_month_outlined,
                textFieldName: "Birth Date",
                readOnly: true,
                onTap: () => _pickBirthDate(context),
                validator: validateBirthDate,
                formFieldKey: birthDateKey,
              ),
              SizedBox(height: 15),
              Row(
                spacing: 15,
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: "Enter your height (cm)",
                      controller: heightController,
                      icon: Icons.height,
                      keyboardType: TextInputType.number,
                      textFieldName: "Height (optional)",
                      validator: validateHeight,
                      formFieldKey: heightKey,
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      hintText: "Enter your weight (kg)",
                      controller: weightController,
                      icon: Icons.monitor_weight,
                      keyboardType: TextInputType.number,
                      textFieldName: "Weight (optional)",
                      validator: validateWeight,
                      formFieldKey: weightKey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              const Text(
                "Do you suffer from chronic diseases?",
                style: TextStyle(fontSize: 16),
              ),

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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Save Data",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
