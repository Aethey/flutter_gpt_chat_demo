import 'package:flutter_test/flutter_test.dart';
import 'package:whisper_tiny_flutter/whisper_tiny_flutter.dart';
import 'package:whisper_tiny_flutter/whisper_tiny_flutter_platform_interface.dart';

class MockWhisperTinyFlutterPlatform extends WhisperTinyFlutterPlatform {
  @override
  Future<void> startRecording() async {
    // Mock implementation for testing
  }

  @override
  Stream<String> onResultReceived() {
    throw UnimplementedError();
  }
}

void main() {
  final WhisperTinyFlutterPlatform initialPlatform =
      WhisperTinyFlutterPlatform.instance;

  setUp(() {
    WhisperTinyFlutterPlatform.instance = MockWhisperTinyFlutterPlatform();
  });

  tearDown(() {
    WhisperTinyFlutterPlatform.instance = initialPlatform;
  });

  test('startRecording is called', () async {
    await WhisperTinyFlutter().startRecording();
  });
}
