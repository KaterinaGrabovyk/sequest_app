import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('про SkillUp'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SkillUp — це інноваційний додаток для навчання через ваші хобі.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ми використовуємо штучний інтелект (Gemini), щоб створювати '
            'математичні задачі на основі ваших інтересів.',
          ),
          const SizedBox(height: 12),
          const Text(
            'Генерація',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            'Оберіть тему та гобі (або введіть свої), та надішліть запит. '
            'Зачекайте доки в полі не з\'явиться умова задачі.',
          ),
          const Text(
            'Адаптація',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            'Оберіть гобі (або введіть своє),зробіть фотографію задачі та надішліть запит. '
            'Зачекайте доки в полі не з\'явиться перероблена умова задачі.',
          ),
          const Text(
            'Враховуйте, що тема та гобі задач мають бути коректними, інакше ШІ напише про помилку. ',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),
          Text(
            'Версія: 1.0.4',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Зрозуміло'),
        ),
      ],
    );
  }
}
