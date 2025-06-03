import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_lens/features/analysisImage/model/meal_analysis_model.dart';
import 'package:food_lens/features/analysisImage/viewmodel/cubit/analysis_cubit.dart';
import 'package:food_lens/features/analysisImage/viewmodel/repositories/analysis_repository.dart';

class ResultScreen extends StatelessWidget {
  final String healthConditions;
  final File imageFile;
  final String portionSize;

  const ResultScreen({
    super.key,
    required this.imageFile,
    required this.portionSize,
    required this.healthConditions,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AnalysisCubit(AnalysisRepository())..analyzeImage(
            imageFile: imageFile,
            portionSize: portionSize,
            healthConditions: healthConditions,
          ),
      child: Scaffold(
        appBar: AppBar(title: const Text("Analysis Result")),
        body: ResultScreenBody(imageFile: imageFile),
      ),
    );
  }
}

class ResultScreenBody extends StatelessWidget {
  final File imageFile;

  const ResultScreenBody({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisCubit, AnalysisState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildImagePreview(imageFile, state is AnalysisLoading),
              const SizedBox(height: 20),
              _buildResultContent(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePreview(File imageFile, bool isLoading) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            imageFile,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      "Analyzing image...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResultContent(AnalysisState state) {
    if (state is AnalysisError) {
      return _buildErrorCard(state.message);
    } else if (state is AnalysisSuccess) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Analysis Result",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFormattedResult(state.responseData),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildErrorCard(String error) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Card(
        color: Colors.red.shade50,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  error,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormattedResult(String rawText) {

    final MealAnalysisModel model = MealAnalysisModel.fromRawText(rawText);

    final sectionWidgets = <Widget>[];
    sectionWidgets.add(_buildHeaderCard(model.detectedFood, model.confidence));

    model.sections.forEach((title, items) {
      sectionWidgets.add(_buildSectionCard(title, items));
    });

    return Column(children: sectionWidgets);
  }

  Widget _buildSectionCard(String title, List<String> items) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getSectionIcon(title), color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(item, style: const TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(String foodName, String confidence) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.restaurant_menu,
              color: Colors.deepOrange,
              size: 40,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Confidence: $confidence",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSectionIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('nutritional')) return Icons.local_fire_department;
    if (lower.contains('macronutrients')) return Icons.fitness_center;
    if (lower.contains('detailed')) return Icons.info_outline;
    if (lower.contains('minerals')) return Icons.science;
    if (lower.contains('health')) return Icons.health_and_safety;
    if (lower.contains('portion')) return Icons.dining;
    return Icons.label;
  }
}
