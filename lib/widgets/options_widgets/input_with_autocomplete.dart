import 'package:flutter/material.dart';

class InputWithAutocomplete extends StatelessWidget {
  const InputWithAutocomplete({
    super.key,
    required this.inputText,
    required this.autocomleteItemsList,
    required this.onSelectedParam,
    required this.inputColor,
  });
  final String inputText;
  final List<String> autocomleteItemsList;
  final Function(String) onSelectedParam;
  final Color inputColor;
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
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              height: inputText == 'Тема' ? 120 : 80,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },

      fieldViewBuilder:
          (
            context,
            textEditingController,
            focusNode,
            onFieldSubmitted,
          ) {
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
                    value.length < 3) {
                  return '$inputText має бути мінімум 3 символів';
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
