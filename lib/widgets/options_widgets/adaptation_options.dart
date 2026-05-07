import 'package:flutter/material.dart';
import 'package:skill_up_app/data/base_data.dart';
import 'package:skill_up_app/widgets/img_picker.dart';
import 'package:skill_up_app/widgets/options_widgets/input_with_autocomplete.dart';
import 'dart:io';

class AdaptationOptions extends StatefulWidget {
  const AdaptationOptions({
    super.key,
    required this.colorScheme,
    required this.hobbyController,
    required this.onImageChanged,
    required this.onHobbyChanged,
  });

  final ColorScheme colorScheme;
  final TextEditingController hobbyController;
  final Function(File) onImageChanged;
  final Function(String) onHobbyChanged;
  @override
  State<AdaptationOptions> createState() =>
      _AdaptationOptionsState();
}

class _AdaptationOptionsState extends State<AdaptationOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImageInput(
          onSelectImage: (value) {
            widget.onImageChanged(value);
          },
        ),
        InputWithAutocomplete(
          inputText: 'Гоббі/Інтерес',
          autocomleteItemsList: baseHobbyList,
          onSelectedParam: (value) {
            widget.onHobbyChanged(value);
          },
          inputColor: widget.colorScheme.onPrimary,
          controller: widget.hobbyController,
        ),
      ],
    );
  }
}
