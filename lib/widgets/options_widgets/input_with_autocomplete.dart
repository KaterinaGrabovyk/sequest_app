import 'package:flutter/material.dart';

class InputWithAutocomplete extends StatelessWidget {
  const InputWithAutocomplete({
    super.key,
    required this.inputText,
    required this.autocomleteItemsList,
    required this.onSelectedParam,
    required this.inputColor,
    this.controller,
  });
  final String inputText;
  final List<String> autocomleteItemsList;
  final Function(String) onSelectedParam;
  final Color inputColor;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEdVal) {
        if (textEdVal.text == '') {
          return autocomleteItemsList;
        }
        return autocomleteItemsList.where((String item) {
          return item.toLowerCase().contains(
            textEdVal.text.toLowerCase(),
          );
        });
      },
      fieldViewBuilder:
          (
            context,
            textEditingController,
            focusNode,
            onFieldSubmitted,
          ) {
            if (controller != null &&
                controller!.text != textEditingController.text) {
              if (controller!.text.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  textEditingController.clear();
                });
              }
            }
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              maxLength: 60,
              onSaved: (value) {
                onSelectedParam(value!);
                onFieldSubmitted();
              },
              validator: (value) {
                if (value == null ||
                    value == '' ||
                    value.length < 4) {
                  return '$inputText має бути довше 3х символів';
                }
                return null;
              },

              style: TextStyle(color: inputColor),
              cursorColor: inputColor,

              decoration: InputDecoration(
                labelText: inputText,
                suffix: IconButton(
                  onPressed: () {
                    textEditingController.clear();
                    onSelectedParam('');
                  },
                  icon: Icon(Icons.cancel),
                  style: IconButton.styleFrom(
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.error,
                    padding: EdgeInsets.all(0),
                  ),
                ),
                counterStyle: TextStyle(color: inputColor),
                labelStyle: TextStyle(color: inputColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: inputColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: inputColor),
                ),
              ),
            );
          },
    );
  }
}
