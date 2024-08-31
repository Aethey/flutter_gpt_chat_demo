import 'package:whisper_tiny_flutter/whisper_tiny_flutter.dart';

class SpeechRecognitionRepository {
  static final SpeechRecognitionRepository _singleton =
      SpeechRecognitionRepository._internal();

  factory SpeechRecognitionRepository() {
    return _singleton;
  }

  SpeechRecognitionRepository._internal() {
    _whisperTinyFlutterPlugin.onResultReceived((result) {
      _handleResult(result);
    });
  }

  final WhisperTinyFlutter _whisperTinyFlutterPlugin = WhisperTinyFlutter();

  Function(String)? _resultCallback;

  void setResultCallback(Function(String) callback) {
    _resultCallback = callback;
  }

  void _handleResult(String result) {
    if (_resultCallback != null) {
      _resultCallback!(result);
    }
  }

  Future<void> startRecording() async {
    await _whisperTinyFlutterPlugin.startRecording();
  }

  Future<void> stopRecording() async {
    await _whisperTinyFlutterPlugin.stopRecording();
  }
}
