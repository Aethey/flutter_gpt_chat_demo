import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ry_chat/config_dev.dart';

typedef OnStreamStopCallback = void Function(String totalMessage);

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
    // Add interceptors for logging, error handling, etc.
    _dio.interceptors.add(LogInterceptor(responseBody: false));
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, handler) {
        // Custom error handling
        if (kDebugMode) {
          print('DIO ERROR: ${e.message}');
        }
        return handler.next(e);
      },
    ));
  }

  // Regular API call common
  Future<Response> fetchRegularResponse(String path,
      {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Streamed API call for continuous responses
  Future<void> fetchStreamResponse(
      {required StreamController<String> controller,
      required String userMessage,
      required OnStreamStopCallback onStreamStopCallback}) async {
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
            String stringData = utf8.decode(data);
            sink.add(stringData);
            print(stringData);
          }, handleError: (error, stackTrace, sink) {
            sink.addError('process data error: $error');
          }, handleDone: (sink) {
            sink.close();
          }))
          .transform(const LineSplitter())
          .listen((dataLine) {
        if (dataLine.isEmpty || dataLine == 'data: [DONE]') {
          return;
        }
        final jsonMap = json.decode(dataLine.replaceAll('data: ', ''));
        if (jsonMap['choices'][0]['finish_reason'] == 'stop') {
          return;
        }
        String content = jsonMap['choices'][0]['delta']['content'] ?? '';
        accumulatedContent.write(content);
        controller.add(accumulatedContent.toString());
      }, onDone: () {
        controller.close();
        onStreamStopCallback(accumulatedContent.toString() ?? "");
      }, onError: (e) {
        controller.addError('request data failed: $e');
        controller.close();
        onStreamStopCallback(accumulatedContent.toString() ?? "");
      });
    } catch (e) {
      controller.addError(_handleError(e));
      controller.close();
      onStreamStopCallback(accumulatedContent.toString() ?? "");
    } finally {
      // process every time
      // controller.close();
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      return Exception('API request failed: ${error.message}');
    }
    return Exception('An unexpected error occurred: $error');
  }
}
