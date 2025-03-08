import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Screen'),
        ),
        body: SizedBox(
          height: 100,
          child: Center(child: Text('data')),
        ),
        //drawer: Drawer(),
        // floatingActionButton: Stack(
        //   children: [
        //     Align(
        //       alignment: Alignment.bottomRight,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: [
        //           FloatingActionButton(
        //             onPressed: () {},
        //             child: Icon(Icons.camera),
        //           ),
        //           SizedBox(height: 20),
        //           FloatingActionButton(
        //             onPressed: () {},
        //             child: Icon(Icons.chat),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// //import 'package:fl_chart/fl_chart.dart'; // لمخططات البيانات

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(),
//       body: _buildBody(context),
//       floatingActionButton: _buildChatBotButton(),
//     );
//   }
// }

// AppBar _buildAppBar() {
//   return AppBar(
//     title: Text("FoodLens", style: TextStyle(fontWeight: FontWeight.bold)),
//     actions: [
//       IconButton( onPressed: () {} ,icon: Icon(Icons.notifications)), // أيقونة الإشعارات
//       IconButton(onPressed: () {
        
//       } ,icon: Icon(Icons.person)), // أيقونة الملف الشخصي
//     ],
//     leading: IconButton( onPressed: (){},icon: Icon(Icons.menu)), // أيقونة القائمة الجانبية
//   );
// }


// Widget _buildBody(BuildContext context) {
//   return SingleChildScrollView(
//     child: Column(
//       children: [
//         // زر التقاط الصورة
//         _buildCaptureButton(context),
//         // نتائج التحليل (تظهر بعد رفع الصورة)
//         _buildAnalysisResult(),
//         // التتبع اليومي
//         _buildDailyProgress(),
//         // الموارد التعليمية
//         _buildEducationalResources(),
//       ],
//     ),
//   );
// }

// // زر التقاط الصورة
// Widget _buildCaptureButton(BuildContext context) {
//   return GestureDetector(
//     onTap: () => _captureImage(context), // دالة لالتقاط الصورة
//     child: Container(
//       width: 150,
//       height: 150,
//       decoration: BoxDecoration(
//         color: Colors.orangeAccent,
//         shape: BoxShape.circle,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.camera_alt, size: 40, color: Colors.white),
//           Text("اضغط لتحليل وجبتك!", style: TextStyle(color: Colors.white)),
//         ],
//       ),
//     ),
//   );
// }

// // بطاقة نتائج التحليل
// Widget _buildAnalysisResult() {
//   return Card(
//     child: Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Text("🍣 سلطة دجاج", style: TextStyle(fontSize: 18)),
//           SizedBox(height: 8),
//           Text("350 kcal | 🟢 مناسبة لضغط الدم"),
//           SizedBox(height: 8),
//           Text("💡 تجنب إضافة الملح"),
//         ],
//       ),
//     ),
//   );
// }

// Widget _buildDailyProgress() {
//   return Padding(
//     padding: EdgeInsets.all(16),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("التتبع اليومي", style: TextStyle(fontSize: 20)),
//         SizedBox(height: 16),
//         // Container(
//         //   height: 200,
//         //   child: BarChart(
//         //     BarChartData(
//         //       // إعداد بيانات المخطط هنا
//         //     ),
//         //   ),
//         // ),
//       ],
//     ),
//   );
// }

// Widget _buildEducationalResources() {
//   return Padding(
//     padding: EdgeInsets.all(16),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("الموارد التعليمية", style: TextStyle(fontSize: 20)),
//         SizedBox(height: 16),
//         Container(
//           height: 120,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: [
//               _buildResourceCard("📚 نصائح لمرضى السكري"),
//               _buildResourceCard("🥑 وصفات صحية"),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildResourceCard(String title) {
//   return Container(
//     width: 150,
//     margin: EdgeInsets.only(right: 8),
//     decoration: BoxDecoration(
//       color: Colors.green[100],
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Center(child: Text(title)),
//   );
// }

// Widget _buildChatBotButton() {
//   return FloatingActionButton(
//     onPressed: () {},
//     backgroundColor: Colors.blue, // دالة لفتح الدردشة
//     child:  Icon(Icons.chat, color: Colors.white),
//   );
// }

// void _captureImage(BuildContext context) async {
//   // // 1. التقاط الصورة من الكاميرا أو المعرض
//   // //final image = await ImagePicker().pickImage(source: ImageSource.camera);

//   // if (image != null) {
//   //   // 2. إرسال الصورة إلى API لتحليلها
//   //   //var response = await FoodLensAPI.analyzeImage(image.path);

//   //   // 3. عرض النتائج
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: Text("النتائج"),
//   //       content: Text("السعرات الحرارية: ${response.calories}"),
//   //     ),
//   //   );
//   // }
// }