import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/constans/constans.dart';

class AnalysisRepository {

  Future<String> fetchApiUrl() async {
    final response = await http.get(
      Uri.parse(Constants.analyzeImageApiKey),
    );
    if (response.statusCode == 200) {
      final url = response.body.trim().replaceAll('"', '');
      return url;
    } else {
      throw Exception('Failed to fetch API URL');
    }
  }

  Future<String> analyzeImage({
    required File imageFile,
    required String portionSize,
    required String healthConditions,
  }) async {
    final apiUrl = await fetchApiUrl();
    final uri = Uri.parse(apiUrl);
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    request.fields['portion_size'] = portionSize;
    request.fields['health_conditions'] = healthConditions;

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to analyze image. \nThe uploaded image doesn't appear to contain food.",
      );
    }
    return responseBody;
  }
}
