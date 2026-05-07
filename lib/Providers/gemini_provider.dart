import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GroqProvider extends StateNotifier<String> {
  GroqProvider() : super('');

  Future<void> generateProblem({
    String? topic,
    String? image,
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
    final prompt = image != null ? adaptationP : generationP;
    state = 'loading';
    try {
      final apiKey = dotenv.get('GEMINI_API_KEY');
      final url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite-preview:generateContent?key=$apiKey';
      final body = {
        "contents": [
          {
            "parts": [
              {"text": prompt},
              if (image != null && image != 'no-img')
                {
                  "inline_data": {
                    "mime_type": "image/jpeg",
                    "data": image,
                  },
                },
            ],
          },
        ],
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String textResponse =
            data['candidates'][0]['content']['parts'][0]['text'];
        state = textResponse;
        print('Успішно');
      } else {
        print('Помилка: ${response.statusCode}');
        state = 'Помилка: ${response.statusCode}';
      }
    } catch (error) {
      state = 'Помилка: $error';
    }
  }
}

final groqResponseProvider =
    StateNotifierProvider<GroqProvider, String>(
      (ref) => GroqProvider(),
    );
