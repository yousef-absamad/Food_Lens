import 'package:flutter/material.dart';
import '../Profile/screens/profile_screen.dart';
import '../captureImage/screens/camera_screen.dart'; 
import 'screens/home_screen.dart'; 

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomeScreen(), 
    CameraScreen(), 
    ChatBotScreen(), 
    //EducationalScreen(), 
    ProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: "Camera",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "chatbot"),
          BottomNavigationBarItem(
            icon: Icon(Icons.cast_for_education),
            label: "Educational",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatbot")),
      body: Center(
        child: Text("هذه شاشة الدردشة"),
      ),
    );
  }
}