import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'whisper_tiny_flutter_method_channel.dart';

abstract class WhisperTinyFlutterPlatform extends PlatformInterface {
  /// Constructs a WhisperTinyFlutterPlatform.
  WhisperTinyFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static WhisperTinyFlutterPlatform _instance =
      MethodChannelWhisperTinyFlutter();

  /// The default instance of [WhisperTinyFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelWhisperTinyFlutter].
  static WhisperTinyFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WhisperTinyFlutterPlatform] when
  /// they register themselves.
  static set instance(WhisperTinyFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> startRecording() {
    throw UnimplementedError('startRecording() has not been implemented.');
  }

  Future<void> stopRecording() {
    throw UnimplementedError(
        'stopRecordingAndGetPath() has not been implemented.');
  }

  Future<void> startTranscription(String filePath) {
    throw UnimplementedError('startTranscription() has not been implemented.');
  }

  Future<void> stopTranscription() {
    throw UnimplementedError('stopTranscription() has not been implemented.');
  }

  Stream<String> onResultReceived();
}
