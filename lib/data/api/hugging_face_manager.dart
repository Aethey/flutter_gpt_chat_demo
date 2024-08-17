import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String? apiKey = dotenv.env['HUGGING_FACE_API_KEY'];

class HuggingFaceManager {
  // Private constructor for Singleton
  HuggingFaceManager._privateConstructor();

  // Static instance of the Singleton
  static HuggingFaceManager? _instance;

  // Public factory constructor to ensure only one instance
  factory HuggingFaceManager() {
    _instance ??= HuggingFaceManager._privateConstructor();
    return _instance!;
  }

  // Method to call the Hugging Face Inference API
  Future<String> callHuggingFaceApi(
      String modelUrl, Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        Uri.parse(modelUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result.toString();
      } else {
        return "Failed: ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
