import 'dart:io';
import 'package:flutter/material.dart';
import 'result_screen.dart';

class PreviewScreen extends StatefulWidget {
  final File imageFile;
  final String healthConditions;

  const PreviewScreen({super.key, required this.imageFile , required this.healthConditions});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  String _selectedPortion = 'medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Image')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  widget.imageFile,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Portion Size",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                children:
                    ['small', 'medium', 'large'].map((portion) {
                      return ChoiceChip(
                        label: Text(
                          portion[0].toUpperCase() + portion.substring(1),
                        ), // يعرض أول حرف Capital
                        selected: _selectedPortion == portion,
                        onSelected: (_) {
                          setState(() => _selectedPortion = portion);
                        },
                        selectedColor: Colors.teal,
                        labelStyle: TextStyle(
                          color:
                              _selectedPortion == portion
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      );
                    }).toList(),
              ),

              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ResultScreen(
                                  imageFile: widget.imageFile,
                                  portionSize: _selectedPortion.toLowerCase(),
                                  healthConditions: widget.healthConditions,
                                ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.analytics, color: Colors.white),
                      label: const Text(
                        "Analyze",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
