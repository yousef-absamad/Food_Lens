import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // مهم جداً
import 'package:food_lens/features/Profile/model/user_model.dart';
import 'package:food_lens/features/Profile/views/widgets/profile_form_content.dart';

import '../../view model/logic/profile_form_view_model.dart';
import '../../view model/repo/user_epository.dart';

class UpdateProfileScreen extends StatelessWidget {
  final UserModel? userModel;

  const UpdateProfileScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Profile")),
      body: ChangeNotifierProvider(
        create: (_) => ProfileFormViewModel(UserRepository(), ProfileMode.update , userModel: userModel),
        child: ProfileFormContent(
          profileMode: ProfileMode.update,
          onSaveText: 'Update Data',
          illustrationsPath: 'assets/image/Update-pana.svg',
        ),
      ),
    );
  }
}
