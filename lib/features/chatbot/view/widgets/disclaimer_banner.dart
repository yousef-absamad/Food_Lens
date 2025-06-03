import 'package:flutter/material.dart';

class MedicalChatDisclaimer extends StatelessWidget {
  const MedicalChatDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'مرحبًا بك في المساعد الطبي الذكي ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                12,
              ), 
              child: Image.asset(
                'assets/image/chatdoctor.png',
              ),
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            'أنا هنا علشان أساعدك بمعلومات عن التغذية والأمراض المزمنة.\n\n'
            '❗تنبيه: هذا الشات لا يغني عن استشارة الطبيب، ولا يقدم تشخيصاً أو علاجاً لحالة صحية.\n'
            'استشر مختصاً عند الحاجة.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
