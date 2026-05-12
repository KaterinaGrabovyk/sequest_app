import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_up_app/Providers/gemini_provider.dart';
import 'package:skill_up_app/widgets/math_text_adapt.dart';

class Result extends ConsumerWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final response = ref.watch(aiResponseProvider);

    Widget content;

    if (response == 'loading') {
      content = Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      );
    } else if (response.isEmpty) {
      content = Text(
        'Ще не має задачі, згенеруйте нову!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      );
    } else {
      content = SingleChildScrollView(
        child: MarkdownBody(
          data: response,
          inlineSyntaxes: [LatexSyntax()],
          builders: {
            'latex': LatexBuilder(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight(700),
              ),
            ),
          },
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            pPadding: EdgeInsets.zero,
            blockSpacing: 8,
          ),
        ),
      );
    }

    return Container(
      height: 250,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: content,
    );
  }
}
