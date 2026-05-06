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
