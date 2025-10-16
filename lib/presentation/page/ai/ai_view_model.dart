import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chat {
  final String content;
  final bool isReceived;
  const Chat({required this.content, required this.isReceived});

  void operator [](String other) {}
}

class AiViewModel extends Notifier<List<Chat>> {
  @override
  List<Chat> build() {
    return [
      const Chat(
        content: '안녕하세요! 아래 버튼을 눌러주세요. 잠시만 기달리면 답변을 받을수 있습니다.',
        isReceived: true,
      ),
    ];
  }

  final _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
  );

  String _cleanMarkdown(String text) {
    return text
        .replaceAll(RegExp(r'[#*]+'), '') // remove markdown symbols
        .replaceAll(RegExp(r'\s{2,}'), ' ') // clean extra spaces
        .trim();
  }

  void send(String text) async {
    print(const String.fromEnvironment('GEMINI_API_KEY'));
    state = [...state, Chat(content: text, isReceived: false)];
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final result = await _model.generateContent([Content.text(text)]);
      if (result.text != null) {
        final cleaned = _cleanMarkdown(result.text!);
        state = [...state, Chat(content: cleaned, isReceived: true)];
      } else {
        state = [
          ...state,
          Chat(content: 'AI의 응답을 가져오지 못했습니다.', isReceived: true),
        ];
      }
    } catch (e) {
      state = [...state, Chat(content: '오류 발생: $e', isReceived: true)];
    }
  }

  Future<void> analyzeTransactions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .get();

    final buffer = StringBuffer();
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final category = data['category'] ?? 'Unknown';
      final amount = data['amount'] ?? 0;
      buffer.writeln('$category: $amount');
    }

    final prompt =
        '''
아래는 사용자의 소비 내역입니다. 각 카테고리별 금액을 분석하고,
수입과 지출의 균형, 절약 또는 개선 포인트를 간결하고 자연스러운 한국어로 요약해 주세요.

${buffer.toString()}

출력 형식 예시:
- 요약: 사용자는 교육비 지출이 수입보다 많아 적자가 발생했습니다.
- 조언: 향후 교육비 지출을 줄이거나 추가 수입원을 고려해야 합니다.
''';

    try {
      final result = await _model.generateContent([Content.text(prompt)]);
      if (result.text != null) {
        final cleaned = _cleanMarkdown(result.text!);
        state = [...state, Chat(content: cleaned, isReceived: true)];
      }
    } catch (e) {
      state = [...state, Chat(content: '오류 발생: $e', isReceived: true)];
    }
  }

  void update(List Function(dynamic state) param0) {}
}

final aiViewModel = NotifierProvider<AiViewModel, List<Chat>>(
  () => AiViewModel(),
);
