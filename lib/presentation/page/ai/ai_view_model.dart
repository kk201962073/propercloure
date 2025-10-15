import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Chat {
  final String content;
  final bool isReceived;
  const Chat({required this.content, required this.isReceived});

  void operator [](String other) {}
}

class AiViewModel extends Notifier<List<Chat>> {
  @override
  List<Chat> build() {
    return [];
  }

  final _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
  );

  void send(String text) async {
    state = [...state, Chat(content: text, isReceived: false)];

    final result = await _model.generateContent([Content.text(text)]);
    if (result.text != null) {
      state = [...state, Chat(content: result.text!, isReceived: true)];
    }
  }
}

final aiViewModel = NotifierProvider<AiViewModel, List<Chat>>(
  () => AiViewModel(),
);
