import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../view model/logic/profile_form_view_model.dart';

class ProfileFormContent extends StatefulWidget {
  final String illustrationsPath;
  final String onSaveText;
  final ProfileMode profileMode;

  const ProfileFormContent({
    super.key,
    required this.illustrationsPath,
    required this.onSaveText,
    required this.profileMode,
  });

  @override
  State<ProfileFormContent> createState() => _ProfileFormContentState();
}

class _ProfileFormContentState extends State<ProfileFormContent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileFormViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.loadStatus == ProfileLoadStatus.loading ||
            viewModel.saveOrUpdateStatus == ProfileSaveOrUpdateStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.saveOrUpdateStatus == ProfileSaveOrUpdateStatus.success) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  viewModel.profileMode == ProfileMode.complete
                      ? 'Data saved'
                      : 'Data updated',
                ),
                backgroundColor: Colors.green,
              ),
            );
          });
        }

   
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250,
                  child: SvgPicture.asset(widget.illustrationsPath),
                ),           
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gender',
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: viewModel.selectedGender,
                      key: viewModel.genderKey,
                      decoration: InputDecoration(
                        hintText: "Select Gender",
                        filled: true,
                        fillColor: Colors.grey[200],
                        prefixIcon: const Icon(Icons.transgender, color: Colors.green),
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
                          viewModel.selectedGender = value;
                        });
                      },
                      validator: viewModel.validateGender,
                      borderRadius: BorderRadius.circular(12),
                      elevation: 4,
                    ),
                  ],
                ),

                CustomTextField(
                  hintText: 'Select Birth Date',
                  controller: viewModel.birthDateController,
                  icon: Icons.calendar_month_outlined,
                  textFieldName: "Birth Date",
                  readOnly: true,
                  onTap: () async {
                    await viewModel.pickBirthDate(context);
                    setState(() {});
                  },
                  validator: viewModel.validateBirthDate,
                  formFieldKey: viewModel.birthDateKey,
                ),

                Row(
                  spacing: 15,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: "Enter your height (cm)",
                        controller: viewModel.heightController,
                        icon: Icons.height,
                        keyboardType: TextInputType.number,
                        textFieldName: "Height (optional)",
                        validator: viewModel.validateHeight,
                        formFieldKey: viewModel.heightKey,
                      ),
                    ),
                    Expanded(
                      child: CustomTextField(
                        hintText: "Enter your weight (kg)",
                        controller: viewModel.weightController,
                        icon: Icons.monitor_weight,
                        keyboardType: TextInputType.number,
                        textFieldName: "Weight (optional)",
                        validator: viewModel.validateWeight,
                        formFieldKey: viewModel.weightKey,
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    const Text(
                      "Do you suffer from chronic diseases?",
                      style: TextStyle(fontSize: 18),
                    ),
                    CheckboxListTile(
                      title: const Text("Diabetes"),
                      value: viewModel.hasDiabetes,
                      activeColor: Colors.green,
                      visualDensity: VisualDensity.compact,
                      onChanged: (value) {
                        setState(() {
                          viewModel.hasDiabetes = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("Hypertension"),
                      value: viewModel.hasHypertension,
                      activeColor: Colors.green,
                      visualDensity: VisualDensity.compact,
                      onChanged: (value) {
                        setState(() {
                          viewModel.hasHypertension = value ?? false;
                        });
                      },
                    ),
                  ],
                ),

                Column(
                  children: [
                    const SizedBox(height: 15),
                    CustomButton(
                      label: widget.onSaveText,
                      onPressed: viewModel.hasChanges
                          ? () async {
                              await viewModel.saveOrUpdateData(context);
                            }
                          : null,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}