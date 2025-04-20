import 'package:flutter/material.dart';
import 'package:food_lens/features/Profile/views/widgets/profile_form_content.dart';
import 'package:provider/provider.dart';

import '../../view model/logic/profile_form_view_model.dart';
import '../../view model/repo/user_epository.dart';

class CompleteProfileScreen extends StatelessWidget {
  
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complete Profile")),
      body: ChangeNotifierProvider(
        create: (_) => ProfileFormViewModel(UserRepository(), ProfileMode.complete),
        child: ProfileFormContent(
          profileMode: ProfileMode.complete,
          illustrationsPath: 'assets/image/CompleteProfile.svg',
          onSaveText: 'Save Data',
        ),
      ),
    );
  }
}
