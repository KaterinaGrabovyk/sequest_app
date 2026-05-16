import 'package:flutter_test/flutter_test.dart';
import 'package:skill_up_app/Providers/user_data_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skill_up_app/Providers/ai_service.dart';

// Імпортуй правильні шляхи до своїх файлів
import 'package:skill_up_app/Providers/gemini_provider.dart';

// Створюємо мок для нашого нового сервісу
class MockAIService extends Mock implements AIService {}

void main() {
  group('UserDataProvider Тести', () {
    const dbTitle = 'test_database';
    late UserDataProvider provider;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      provider = UserDataProvider(dbTitle);
    });

    test('Початковий стан має бути порожнім', () {
      expect(provider.state, isEmpty);
    });

    test(
      'addItem коректно додає новий елемент і сортує його на початок',
      () {
        provider.addItem('Перша задача');
        provider.addItem('Друга задача');

        final state = provider.state;
        expect(state.length, 2);
        expect(
          state.first['title'],
          'Друга задача',
        ); // Остання додана має бути першою
      },
    );

    test('editItem успішно змінює заголовок за ID', () {
      provider.addItem('Оригінальний заголовок');
      final id = provider.state.first['id']!;

      provider.editItem(id, 'Оновлений заголовок');

      expect(provider.state.first['title'], 'Оновлений заголовок');
    });

    test('deleteItem видаляє елемент зі списку', () {
      provider.addItem('Задача для видалення');
      final id = provider.state.first['id']!;

      provider.deleteItem(id);

      expect(provider.state, isEmpty);
    });
  });

  group('AIProvider Тести з Моками', () {
    late AIProvider aiProvider;
    late MockAIService mockAIService;

    setUp(() {
      mockAIService = MockAIService();
      aiProvider = AIProvider(aiService: mockAIService);
    });

    test('Початковий стан має бути порожнім рядком', () {
      expect(aiProvider.state, '');
    });

    test(
      'Успішна генерація задачі без зображення (текстовий prompt)',
      () async {
        const expectedResponse = 'Геймер Вася має 5 яблук...';

        when(
          () => mockAIService.generateContent(
            textPrompt: any(named: 'textPrompt'),
            image: null,
          ),
        ).thenAnswer((invocation) async {
          // Отримуємо аргумент, який реально прийшов у метод під час тесту

          // Виводимо гарний аутпут у консоль
          print('\n [AI TEST LOG] Виклик generateContent():');
          print(
            ' Згенерована відповідь моку:\n$expectedResponse\n',
          );

          return expectedResponse;
        });

        await aiProvider.generateProblem(
          topic: 'Математика',
          hobby: 'Ігри',
          isAdapation: false,
        );

        expect(aiProvider.state, expectedResponse);
      },
    );

    test(
      'Повернення помилки, якщо сервіс повернув null або порожній рядок',
      () async {
        when(
          () => mockAIService.generateContent(
            textPrompt: any(named: 'textPrompt'),
            image: null,
          ),
        ).thenAnswer((invocation) async {
          print(
            '\n [AI TEST LOG] Тест порожньої відповіді від моделі.',
          );
          return '';
        });

        await aiProvider.generateProblem(
          topic: 'Математика',
          hobby: 'Ігри',
          isAdapation: false,
        );

        expect(
          aiProvider.state,
          'Помилка: Модель повернула порожню відповідь',
        );
      },
    );

    test('Обробка виключення (Exception) під час запиту', () async {
      when(
        () => mockAIService.generateContent(
          textPrompt: any(named: 'textPrompt'),
          image: any(named: 'image'),
        ),
      ).thenAnswer((invocation) {
        print(
          '\n[AI TEST LOG] Симуляція помилки мережі (Exception).',
        );
        throw Exception('Network error');
      });

      await aiProvider.generateProblem(
        topic: 'Математика',
        hobby: 'Ігри',
        isAdapation: false,
      );

      expect(
        aiProvider.state,
        contains('Помилка: Exception: Network error'),
      );
    });
  });
}
