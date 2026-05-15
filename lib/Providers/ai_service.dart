import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';

abstract class AIService {
  Future<String?> generateContent({
    required String textPrompt,
    Uint8List? image,
  });
}

class GeminiAIService implements AIService {
  @override
  Future<String?> generateContent({
    required String textPrompt,
    Uint8List? image,
  }) async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.1-flash-lite',
    );

    final prompt = [
      Content.multi([
        TextPart(textPrompt),
        if (image != null) InlineDataPart('image/jpeg', image),
      ]),
    ];

    final response = await model.generateContent(prompt);
    return response.text;
  }
}