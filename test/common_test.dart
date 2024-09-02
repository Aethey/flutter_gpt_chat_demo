import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ry_chat/data/repository/speech_recognition_repository.dart';
import 'package:ry_chat/state/speech_recognition_state.dart';

// Mock class for the repository
class MockSpeechRecognitionRepository extends Mock
    implements SpeechRecognitionRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockSpeechRecognitionRepository mockRepository;
  late SpeechRecognitionNotifier notifier;

  setUp(() {
    mockRepository = MockSpeechRecognitionRepository();
    notifier = SpeechRecognitionNotifier();
  });

  test('UpdateSpeechRecognition updates the content', () {
    notifier.updateSpeechRecognition("Hello");

    expect(notifier.state.content, equals("Hello"));

    notifier.updateSpeechRecognition(" World");

    expect(notifier.state.content, equals("Hello World"));
  });
}
