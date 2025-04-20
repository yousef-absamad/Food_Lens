import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:food_lens/core/widgets/error_screen.dart';
import 'package:food_lens/features/Profile/model/user_model.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/cutom_text_field.dart';
import '../../view model/logic/view_profile_view_model.dart';

class ViewProfileScreen extends StatelessWidget {
  final UserModel? userModel;

  const ViewProfileScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ViewProfileViewModel()..initializeWithUser(userModel),
      child: Consumer<ViewProfileViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.state == ProfileState.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // if (viewModel.state == ProfileState.error) {
          //   return Scaffold(
          //     appBar: AppBar(title: const Text("Your Profile")),
          //     body: ErrorScreen(
          //       errorMessage: viewModel.errorMessage,
          //       onRetry: viewModel.initializeWithUser(userModel),
          //     ),
          //   );
          // }

          return Scaffold(
            appBar: AppBar(title: Text("Your Profile")),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    SizedBox(
                      height: 220,
                      child: SvgPicture.asset('assets/image/profiledata.svg'),
                    ),
                    CustomTextField(
                      controller: viewModel.fullNameController,
                      icon: Icons.person,
                      textFieldName: "Full name",
                      readOnly: true,
                    ),
                    CustomTextField(
                      controller: viewModel.genderController,
                      icon: Icons.transgender,
                      textFieldName: "Gender",
                      readOnly: true,
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: viewModel.birthDateController,
                            icon: Icons.calendar_month_outlined,
                            textFieldName: "Birth Date",
                            readOnly: true,
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: viewModel.ageController,
                            icon: Icons.align_vertical_center_sharp,
                            textFieldName: "Age",
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            hintText: "undefined",
                            controller: viewModel.heightController,
                            icon: Icons.height,
                            keyboardType: TextInputType.number,
                            textFieldName: "Height",
                            readOnly: true,
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            hintText: "undefined",
                            controller: viewModel.weightController,
                            icon: Icons.monitor_weight,
                            keyboardType: TextInputType.number,
                            textFieldName: "Weight",
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: const Text(
                        "chronic diseases?",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    CheckboxListTile(
                      title: const Text("Diabetes"),
                      value: viewModel.hasDiabetes,
                      activeColor: Colors.green,
                      onChanged: null,
                      visualDensity: VisualDensity.compact,
                    ),
                    CheckboxListTile(
                      title: const Text("Hypertension"),
                      value: viewModel.hasHypertension,
                      activeColor: Colors.green,
                      onChanged: null,
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
