class MealAnalysisModel {
  final String detectedFood;
  final String confidence;
  final Map<String, List<String>> sections;

  MealAnalysisModel({
    required this.detectedFood,
    required this.confidence,
    required this.sections,
  });

  factory MealAnalysisModel.fromRawText(String rawText) {
    final lines = rawText
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    String? detectedFood;
    String? confidence;
    final sections = <String, List<String>>{};
    String? currentSection;

    for (final line in lines) {
      if (line.startsWith('Detected Food:')) {
        detectedFood = line.replaceFirst('Detected Food:', '').trim();
      } else if (line.startsWith('Confidence:')) {
        confidence = line.replaceFirst('Confidence:', '').trim();
      } else if (line.startsWith('•')) {
        if (currentSection != null) {
          sections[currentSection] = [
            ...?sections[currentSection],
            line.replaceFirst('•', '').trim(),
          ];
        }
      } else if (!line.contains('---')) {
        currentSection = line.trim();
        sections[currentSection] = [];
      }
    }

    return MealAnalysisModel(
      detectedFood: detectedFood ?? '',
      confidence: confidence ?? '',
      sections: sections,
    );
  }
}
