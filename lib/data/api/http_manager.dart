import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../config_dev.dart';

String? apiKey = dotenv.env['OPENAI_API_KEY'];

// stream callback
Future<void> fetchApiResponse(
    StreamController<String> controller, String userMessage) async {
  final client = http.Client();
  StringBuffer accumulatedContent = StringBuffer();

  var request = http.Request(
    'POST',
    Uri.parse('https://api.openai.com/v1/chat/completions'),
  );
  Map<String, dynamic> body = {
    "model": AppConfig.commonModel,
    "messages": [
      {"role": "user", "content": userMessage}
    ],
    "stream": true
  };

  Map<String, String> header = {
    'accept': 'text/event-stream',
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json'
  };
  header.forEach((key, value) {
    request.headers[key] = value;
  });

  request.body = jsonEncode(body);

  Future<http.StreamedResponse> response = client.send(request);

  response.asStream().listen((data) {
    data.stream
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .listen(
            (dataLine) {
              if (dataLine.isEmpty || dataLine == 'data: [DONE]') {
                // controller.close();
                if (kDebugMode) {
                  print("DONE");
                }
                return;
              }

              final map = dataLine.replaceAll('data: ', '');
              Map<String, dynamic> data = json.decode(map);

              if (data['choices'][0]['finish_reason'] == 'stop') {
                // controller.close();
                if (kDebugMode) {
                  print("stop");
                }
                return;
              }

              List<dynamic> choices = data["choices"];
              Map<String, dynamic> choice = choices[0];
              Map<String, dynamic> delta = choice["delta"];
              String content = delta["content"] ?? '';
              accumulatedContent.write(content);
              print(content);
              controller.add(accumulatedContent.toString());
            },
            onDone: () => controller.close(),
            onError: (e) {
              controller.addError('Failed to fetch data: $e');
              controller.close();
            });
  });
}
