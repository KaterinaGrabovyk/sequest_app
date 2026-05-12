import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_riverpod/legacy.dart';

class AIProvider extends StateNotifier<String> {
  AIProvider() : super('');

  Future<void> generateProblem({
    String? topic,
    Uint8List? image,
    required String hobby,
  }) async {
    final generationP =
        'Перевір наступні параметри: Тема: $topic Інтерес/Гоббі:$hobby ;'
        'Якщо параметри не відповідають своїм назвам,в кінцевій відповіді поверни ЛИШЕ наступний текст:"Помилка:Задана Тема чи Гоббі є некоректними";'
        'Інакше згенеруй унікальну задачу УКРАЇНСЬКОЮ мовою, без слів інших мов, на вказану тему, адаптовану під гоббі, та поверни ЛИШЕ текст умови.';
    final adaptationP =
        'Перевір наступні параметри: Умова: Умва задачі на зображенні, Інтерес/Гоббі:$hobby ;'
        'Якщо параметри не відповідають своїм назвам,в кінцевій відповіді поверни ЛИШЕ наступний текст:"Помилка:Задана умова чи Гоббі є некоректними";'
        'Інакше адаптуй умову задачі УКРАЇНСЬКОЮ мовою, без слів інших мов, під гоббі, та поверни ЛИШЕ текст умови.';
    final textPrompt = image != null ? adaptationP : generationP;

    state = 'loading';
    try {
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
      final text = response.text;
      if (text != null && text.isNotEmpty) {
        state = text;
      } else {
        state = 'Помилка: Модель повернула порожню відповідь';
      }
    } catch (error) {
      state = 'Помилка: $error';
    }
  }
}

final aiResponseProvider =
    StateNotifierProvider<AIProvider, String>(
      (ref) => AIProvider(),
    );
