import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repository/speech_recognition_repository.dart';

enum RecognitionState {
  initial,
  analysing,
  stop,
  error,
}

class SpeechRecognitionState {
  final RecognitionState state;
  final String? content;
  final String? errorMessage;

  SpeechRecognitionState({
    required this.state,
    this.content,
    this.errorMessage,
  });
  SpeechRecognitionState copyWith({
    RecognitionState? state,
    String? content,
    String? errorMessage,
  }) {
    return SpeechRecognitionState(
      state: state ?? this.state,
      content: content ?? this.content,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory SpeechRecognitionState.initial() =>
      SpeechRecognitionState(state: RecognitionState.initial);
  factory SpeechRecognitionState.analysing() =>
      SpeechRecognitionState(state: RecognitionState.analysing);
  factory SpeechRecognitionState.stop() =>
      SpeechRecognitionState(state: RecognitionState.stop);
  factory SpeechRecognitionState.error(String message) =>
      SpeechRecognitionState(
          state: RecognitionState.error, errorMessage: message);
}

final speechRecognitionProvider = StateNotifierProvider.autoDispose<
    SpeechRecognitionNotifier, SpeechRecognitionState>((ref) {
  return SpeechRecognitionNotifier();
});

class SpeechRecognitionNotifier extends StateNotifier<SpeechRecognitionState> {
  final SpeechRecognitionRepository _repository;
  SpeechRecognitionNotifier()
      : _repository = SpeechRecognitionRepository(),
        super(SpeechRecognitionState.initial()) {
    _repository.setResultCallback((result) {
      updateSpeechRecognition(result);
    });
  }
  void updateSpeechRecognition(String newContent) {
    state = state.copyWith(
      content: (state.content ?? '') + newContent,
    );
  }

  Future<void> startRecording() async {
    state = SpeechRecognitionState.analysing();
    await _repository.startRecording();
  }

  Future<void> stopRecording() async {
    state = SpeechRecognitionState.stop();
    await _repository.stopRecording();
  }
}
