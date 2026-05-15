import 'dart:typed_data';
import 'package:flutter_riverpod/legacy.dart';
import 'ai_service.dart';

class AIProvider extends StateNotifier<String> {
  AIProvider({AIService? aiService})
    : _aiService = aiService ?? GeminiAIService(),
      super('');

  final AIService _aiService;

  Future<void> generateProblem({
    String? topic,
    Uint8List? image,
    required String hobby,
    required bool isAdapation,
  }) async {
    final generationP =
        'Перевір наступні параметри: Тема: $topic Інтерес/Гоббі:$hobby ;'
        'Якщо параметри не відповідють своїм назвам,в кінцевій відповіді поверни ЛИШЕ наступний текст:"Помилка:Задана Тема чи Гоббі є некоректними";'
        'Інакше згенеруй унікальну задачу УКРАЇНСЬКОЮ мовою, без слів інших мов, на вказану тему, адаптовану під гоббі, та поверни ЛИШЕ текст умови.';
    final adaptationP =
        'Перевір наступні параметри: Умова: Умва задачі на зображенні, Інтерес/Гоббі:$hobby ;'
        'Якщо параметри не відповідають своїм назвам,в кінцевій відповіді поверни ЛИШЕ наступний текст:"Помилка:Задана Умова чи Гоббі є некоректними";'
        'Інакше адаптуй умову задачі УКРАЇНСЬКОЮ мовою, без слів інших мов, під гоббі, та поверни ЛИШЕ текст умови.';
    final textPrompt = isAdapation ? adaptationP : generationP;

    state = 'loading';
    try {
      final text = await _aiService.generateContent(
        textPrompt: textPrompt,
        image: image,
      );

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
