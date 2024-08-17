import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/api/hugging_face_manager.dart';

class ApiRequestWidget extends StatefulWidget {
  const ApiRequestWidget({super.key});

  @override
  State<ApiRequestWidget> createState() => _ApiRequestWidgetState();
}

class _ApiRequestWidgetState extends State<ApiRequestWidget> {
  String _result = "Press the button to call Hugging Face API";

  // Use the singleton HuggingFaceManager
  late HuggingFaceManager huggingFaceManager;

  @override
  void initState() {
    super.initState();
    // Initialize the HuggingFaceManager with your API token
    huggingFaceManager = HuggingFaceManager();
  }

  // Hugging Face model URL
  final String modelUrl =
      "https://api-inference.huggingface.co/models/BAAI/bge-m3";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 1.sw * 2 / 3,
              child: Text(
                _result,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> payload = {
                  "inputs": {
                    "source_sentence": "That is a happy person",
                    "sentences": [
                      "That is a happy dog",
                      "That is a very happy person",
                      "Today is a sunny day"
                    ]
                  }
                };
                // Call the HuggingFaceManager to get the result
                String result = await huggingFaceManager.callHuggingFaceApi(
                    modelUrl, payload);
                setState(() {
                  _result = result;
                });
              },
              child: const Text('Call API'),
            ),
          ],
        ),
      ),
    );
  }
}
