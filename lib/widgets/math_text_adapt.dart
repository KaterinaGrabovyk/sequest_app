import 'package:markdown/markdown.dart' as md;
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class LatexBuilder extends MarkdownElementBuilder {
  final TextStyle textStyle;

  LatexBuilder({required this.textStyle});

  @override
  Widget visitElementAfter(
    md.Element element,
    TextStyle? preferredStyle,
  ) {
    final text = element.textContent;

    return Math.tex(
      text,
      textStyle: textStyle,
      mathStyle: MathStyle.text,
    );
  }
}

class LatexSyntax extends md.InlineSyntax {
  LatexSyntax() : super(r'\$((?:\\\$|[^$])+)\$');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final element = md.Element.text('latex', match[1]!);
    parser.addNode(element);
    return true;
  }
}
