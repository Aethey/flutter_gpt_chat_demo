import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'whisper_tiny_flutter_platform_interface.dart';

class MethodChannelWhisperTinyFlutter extends WhisperTinyFlutterPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('whisper_tiny_flutter');
  static const EventChannel _eventChannel =
      EventChannel('whisper_result_channel');

  @override
  Future<void> startRecording() async {
    await methodChannel.invokeMethod('startRecording');
    try {
      await methodChannel.invokeMethod('startRecording');
    } on PlatformException catch (e) {
      debugPrint('Failed to start recording: ${e.message}');
      debugPrint('Error details: ${e.details}');
    }
  }

  @override
  Future<void> stopRecording() async {
    try {
      await methodChannel.invokeMethod('stopRecording');
    } on PlatformException catch (e) {
      debugPrint("Failed to stop recording: '${e.message}'.");
    }
  }

  @override
  Future<void> startTranscription(String filePath) async {
    try {
      await methodChannel
          .invokeMethod('startTranscription', {"filePath": filePath});
    } on PlatformException catch (e) {
      debugPrint("Failed to start transcription: '${e.message}'.");
    }
  }

  @override
  Future<void> stopTranscription() async {
    try {
      await methodChannel.invokeMethod('stopTranscription');
    } on PlatformException catch (e) {
      debugPrint("Failed to stop transcription: '${e.message}'.");
    }
  }

  @override
  Stream<String> onResultReceived() {
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) => event as String);
  }
}
