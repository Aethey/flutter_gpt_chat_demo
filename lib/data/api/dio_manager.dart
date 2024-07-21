import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../config_dev.dart';

class DioManager {
  String? apiKey = dotenv.env['OPENAI_API_KEY'];
  static final DioManager _singleton = DioManager._internal();

  factory DioManager() {
    return _singleton;
  }

  DioManager._internal();

  final Dio _dio = Dio();

  // Configure Dio instance
  void init() {
    _dio.options.baseUrl = 'https://api.openai.com';
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    // Add other Dio configurations here if needed
  }

  // Regular API call common
  Future<Response> fetchRegularResponse(String path,
      {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      // Handle errors or rethrow them
      rethrow;
    }
  }

  // Streamed API call for continuous responses
  Future<void> fetchStreamResponse(
      StreamController<String> controller, String userMessage) async {
    StringBuffer accumulatedContent = StringBuffer();

    Options options = Options(headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
      'Accept': 'text/event-stream',
    }, responseType: ResponseType.stream);

    Map<String, dynamic> body = {
      "model": AppConfig.commonModel,
      "messages": [
        {"role": "user", "content": userMessage}
      ],
      "stream": true
    };

    try {
      Response<ResponseBody> response = await _dio.post(
        '/v1/chat/completions',
        data: jsonEncode(body),
        options: options,
      );

      response.data!.stream
          .transform(StreamTransformer.fromHandlers(
              handleData: (Uint8List data, EventSink<String> sink) {
            // 将字节数据解码为字符串，并将其添加到sink中
            String stringData = utf8.decode(data);
            sink.add(stringData);
          }, handleError: (error, stackTrace, sink) {
            sink.addError('处理数据时发生错误: $error');
          }, handleDone: (sink) {
            sink.close();
          }))
          .transform(LineSplitter())
          .listen(
              (dataLine) {
                if (dataLine.isEmpty || dataLine == 'data: [DONE]') {
                  // controller.close();
                  return;
                }
                final jsonMap = json.decode(dataLine.replaceAll('data: ', ''));
                if (jsonMap['choices'][0]['finish_reason'] == 'stop') {
                  // controller.close();
                  return;
                }
                String content =
                    jsonMap['choices'][0]['delta']['content'] ?? '';
                accumulatedContent.write(content);
                controller.add(accumulatedContent.toString());
              },
              onDone: () => controller.close(),
              onError: (e) {
                controller.addError('request data failed: $e');
                controller.close();
              });
    } catch (e) {
      print('Request failed: $e');
      controller.addError('Failed to fetch data: $e');
      controller.close();
    }
  }
}
