import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_lens/features/Profile/model/user_model.dart';
import 'package:food_lens/features/Profile/view%20model/repo/user_epository.dart';
import 'package:food_lens/features/chatbot/view/screens/chat_screen.dart';
import 'package:food_lens/features/healthContent/Articles/screens/general_health_articles_screen.dart';
import 'package:food_lens/features/healthContent/videos/screens/videos_screen.dart';
import '../Profile/views/screens/profile_screen.dart';
import '../analysisImage/view/screens/scan_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int currentIndex = 0;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userRepo = UserRepository();
    final user = await userRepo.getUserData();
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final String healthConditions = [
      if (currentUser!.hasDiabetes) 'diabetes',
      if (currentUser!.hasHypertension) 'hypertension',
    ].join(',');

    final List<Widget> pages = [
      GeneralHealthArticlesScreen(
        hasChronicDiseases: currentUser!.hasChronicDiseases,
      ),
      ScanScreen(healthConditions: healthConditions),
      ChatScreen(user: currentUser!),
      VideosScreen(hasChronicDiseases: currentUser!.hasChronicDiseases),
      ProfileScreen(userModel: currentUser!, onUserUpdated: _loadUserData),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        currentIndex: currentIndex,
        onTap: (index) {
          FocusManager.instance.primaryFocus?.unfocus();

          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: "Article",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/image/scan-solid-svgrepo-com.svg",
              height: 24,
              width: 26,
              colorFilter: ColorFilter.mode(
                currentIndex == 1 ? Colors.green : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: "Scan meal",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/image/robot-svgrepo-com.svg",
              height: 24,
              width: 26,
              colorFilter: ColorFilter.mode(
                currentIndex == 2 ? Colors.green : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: "chatbot",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/image/video-library-svgrepo-com.svg",
              height: 24,
              width: 26,
              colorFilter: ColorFilter.mode(
                currentIndex == 3 ? Colors.green : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: "Videos",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
