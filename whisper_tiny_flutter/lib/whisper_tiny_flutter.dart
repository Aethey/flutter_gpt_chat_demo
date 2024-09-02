import 'whisper_tiny_flutter_platform_interface.dart';

class WhisperTinyFlutter {
  Future<void> startRecording() async {
    WhisperTinyFlutterPlatform.instance.startRecording();
  }

  Future<void> stopRecording() async {
    WhisperTinyFlutterPlatform.instance.stopRecording();
  }

  Future<void> startTranscription(String filePath) async {
    WhisperTinyFlutterPlatform.instance.startTranscription(filePath);
  }

  Future<void> stopTranscription() async {
    WhisperTinyFlutterPlatform.instance.stopTranscription();
  }

  void onResultReceived(Function(String) onResult) {
    WhisperTinyFlutterPlatform.instance.onResultReceived().listen((result) {
      onResult(result);
    });
  }
}
