import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  bool _isFabExpanded = false;
  bool _isLoading = false; // حالة التحميل

  Future<void> _imageFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = image;
        _isLoading = true; // بدء التحميل
      });

      // ------ محاكاة عملية التحليل ------
      await Future.delayed(Duration(seconds: 2)); 
      // (استبدل هذا بالكود الفعلي مثل استدعاء API)
      // ------ انتهاء المحاكاة ------

      setState(() {
        _isLoading = false; // انتهاء التحميل
      });
    }
    _closeFab();
  }

  Future<void> _imageFromCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imageFile = image;
        _isLoading = true; // بدء التحميل
      });

      // ------ محاكاة عملية التحليل ------
      await Future.delayed(Duration(seconds: 2));
      // (استبدل هذا بالكود الفعلي)
      // ------ انتهاء المحاكاة ------

      setState(() {
        _isLoading = false; // انتهاء التحميل
      });
    }
    _closeFab();
  }

  void _closeFab() {
    setState(() {
      _isFabExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CameraScreen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              CircularProgressIndicator() // مؤشر التحميل
            else if (imageFile != null)
              Image.file(
                File(imageFile!.path),
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              )
            else
              const Text("No image selected"),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isFabExpanded)
            FloatingActionButton(
              heroTag: "camera",
              mini: true,
              onPressed: _imageFromCamera,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          const SizedBox(height: 10),
          if (_isFabExpanded)
            FloatingActionButton(
              heroTag: "gallery",
              mini: true,
              onPressed: _imageFromGallery,
              backgroundColor: Colors.green,
              child: const Icon(Icons.image, color: Colors.white),
            ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "main",
            onPressed: () => setState(() => _isFabExpanded = !_isFabExpanded),
            backgroundColor: Colors.orange,
            child: Icon(
              _isFabExpanded ? Icons.close : Icons.camera,
              color: Colors.white,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}