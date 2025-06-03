import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_lens/features/analysisImage/view/screens/preview_screen.dart';
import 'package:food_lens/features/analysisImage/view/widgets/build_ink_container.dart';
import 'package:image_picker/image_picker.dart';

class ScanScreen extends StatefulWidget {
  final String healthConditions;
  const ScanScreen({super.key, required this.healthConditions});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker picker = ImagePicker();

  Future<void> _imageFromGallery(BuildContext context) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PreviewScreen(imageFile: file , healthConditions: widget.healthConditions,)),
      );
    }
  }

  Future<void> _imageFromCamera(BuildContext context) async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final file = File(image.path);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PreviewScreen(imageFile: file , healthConditions: widget.healthConditions,)),
      );
    }
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan your meal')),
      body: Column(
        children: [
          buildInkContainer(
            color: Colors.indigo,
            icon: Icons.camera_alt,
            label: "Take a Photo",
            onTap: () => _imageFromCamera(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          buildInkContainer(
            color: Colors.teal,
            icon: Icons.photo_library,
            label: "Pick from Gallery",
            onTap: () => _imageFromGallery(context),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
        ],
      ),
    );
  }
}






