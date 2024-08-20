import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/dio_manager.dart';

enum RequestState {
  initial,
  loading,
  success,
  error,
}

final imageGenerationProvider =
    StateNotifierProvider<ImageGenerationNotifier, ImageGenerationState>((ref) {
  return ImageGenerationNotifier();
});

class ImageGenerationState {
  final RequestState state;
  final String? imageUrl;
  final String? errorMessage;

  ImageGenerationState({
    required this.state,
    this.imageUrl,
    this.errorMessage,
  });

  factory ImageGenerationState.initial() =>
      ImageGenerationState(state: RequestState.initial);
  factory ImageGenerationState.loading() =>
      ImageGenerationState(state: RequestState.loading);
  factory ImageGenerationState.success(String imageUrl) =>
      ImageGenerationState(state: RequestState.success, imageUrl: imageUrl);
  factory ImageGenerationState.error(String message) =>
      ImageGenerationState(state: RequestState.error, errorMessage: message);
}

class ImageGenerationNotifier extends StateNotifier<ImageGenerationState> {
  ImageGenerationNotifier() : super(ImageGenerationState.initial());

  final DioManager _dioManager = DioManager();

  Future<void> generateImage() async {
    state = ImageGenerationState.loading();
    // test start
    // await Future.delayed(Duration(seconds: 10));
    // state = ImageGenerationState.success(
    //     "https://images.unsplash.com/photo-1589711461856-b683e0357a24?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8ZnJlZSUyMGltYWdlfGVufDB8fDB8fHww");
    // test over
    try {
      var response = await _dioManager.generateImage(
        prompt: 'sky sun moon fire',
      );

      if (response != null && response.statusCode == 200) {
        String imageUrl = response.data['data'][0]['url'];
        state = ImageGenerationState.success(imageUrl);
      } else {
        state = ImageGenerationState.error('Failed to generate image');
      }
    } catch (e) {
      state = ImageGenerationState.error('Error: $e');
    }
  }
}
