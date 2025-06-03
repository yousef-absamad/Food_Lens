import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "FoodLens Privacy Policy",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _sectionTitle("4.1. Information We Collect"),
            _infoCard([
              "Personal Information:",
              "- Name",
              "- Email address",
              "- Profile picture (if provided)",
              "",
              "Device & Usage Data:",
              "- Device model, OS version",
              "- App usage statistics",
              "- Crash reports",
              "",
              "Image Data:",
              "- Photographs of food you upload for analysis (processed on our servers)."
            ]),

            _sectionTitle("4.2. How We Use Your Information"),
            _infoCard([
              "- Provide & Improve Service: Process images, generate recommendations.",
              "- Communication: Send updates and alerts.",
              "- Analytics & Research: Improve features using usage trends."
            ]),

            _sectionTitle("4.3. Data Sharing & Disclosure"),
            _infoCard([
              "- We don’t sell or rent your Personal Information.",
              "- Shared only with trusted service providers under agreements.",
              "- Disclosed when legally required."
            ]),

            _sectionTitle("4.4. Data Retention"),
            _infoCard([
              "- Personal info retained only as needed or required by law.",
              "- Image data stored for up to 90 days, then anonymized."
            ]),

            _sectionTitle("4.5. Security"),
            _infoCard([
              "- Industry-standard protections (encryption, secure servers).",
              "- No system is 100% secure."
            ]),

            _sectionTitle("4.6. Your Rights"),
            _infoCard([
              "- Access, correct, or delete your data.",
              "- Request data portability.",
              "- Withdraw consent.",
              "- Contact: privacy@foodlens.app"
            ]),

            _sectionTitle("4.7. Children’s Privacy"),
            _infoCard([
              "- App not intended for children under 13.",
              "- We don’t knowingly collect data from children."
            ]),

            _sectionTitle("4.8. Third‑Party Links"),
            _infoCard([
              "- We are not responsible for privacy practices of third-party sites."
            ]),

            _sectionTitle("4.9. International Transfers"),
            _infoCard([
              "- Your data may be processed in servers outside your country.",
              "- We apply necessary safeguards."
            ]),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _infoCard(List<String> lines) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines
              .map((line) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      line,
                      style: const TextStyle(fontSize: 14.5, height: 1.4),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
