import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_up_app/Providers/gemini_provider.dart';
import 'package:skill_up_app/Providers/user_data_provider.dart';
import 'package:skill_up_app/data/base_data.dart';
import 'package:skill_up_app/widgets/options_widgets/adaptation_options.dart';
import 'package:skill_up_app/widgets/options_widgets/generation_options.dart';
import 'dart:io';
// import 'package:flutter/services.dart'; //? to test on assets images

class TaskOptions extends ConsumerStatefulWidget {
  const TaskOptions({super.key});
  @override
  ConsumerState<TaskOptions> createState() => _TaskOptionsState();
}

class _TaskOptionsState extends ConsumerState<TaskOptions> {
  int _groupValue = 0;
  final _formKey = GlobalKey<FormState>();
  var _selectedTopic = '';
  var _selectedHobby = '';
  File? _selectedImage;
  bool isSending = false;
  void _sendPrompt() async {
    setState(() {
      isSending = true;
    });

    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      setState(() {
        isSending = false;
      });

      return;
    }

    _formKey.currentState!.save();
    Uint8List? finalImageBytes;
    //? to test on assets images
    // ByteData bytes = await rootBundle.load('assets/images/ex1.jpg');
    // var buffer = bytes.buffer;
    // var unit8List = buffer.asUint8List(
    //   bytes.offsetInBytes,
    //   bytes.lengthInBytes,
    // );
    // var testImg = base64.encode(unit8List);
    //?-------------------------------
    if (_selectedImage != null) {
      finalImageBytes = await _selectedImage!.readAsBytes();
    }
    await ref
        .read(aiResponseProvider.notifier)
        .generateProblem(
          topic: _selectedTopic,
          hobby: _selectedHobby,
          image: finalImageBytes,
        );
    final task = ref.read(aiResponseProvider);
    if (!task.startsWith('Помилка') && task != 'loading') {
      ref.read(userDataProvider('tasks').notifier).addItem(task);
      _addUserParams();
      setState(() {
        _selectedTopic = '';
        _selectedHobby = '';
        isSending = false;
      });
    }
    setState(() {
      isSending = false;
    });
  }

  void _addUserParams() {
    final allTopics = [
      ...schoolProgram
          .expand((c) => c.disciplines)
          .expand((d) => d.topics)
          .map((topic) => topic.title),
      ...ref
          .watch(userDataProvider('topics'))
          .map((item) => item['title'] as String),
    ];
    final allHobbies = [
      ...baseHobbyList,
      ...ref
          .watch(userDataProvider('hobbies'))
          .map((item) => item['title'] as String),
    ];
    if (!allTopics.contains(_selectedTopic)) {
      ref
          .read(userDataProvider('topics').notifier)
          .addItem(_selectedTopic);
    }
    if (!allHobbies.contains(_selectedHobby)) {
      ref
          .read(userDataProvider('hobbies').notifier)
          .addItem(_selectedHobby);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userTopics = ref
        .watch(userDataProvider('topics'))
        .map((item) => item['title'] as String)
        .toList();
    final allHobbies = [
      ...baseHobbyList,
      ...ref
          .watch(userDataProvider('hobbies'))
          .map((item) => item['title'] as String),
    ];
    final colorScheme = Theme.of(context).colorScheme;
    final segmentTextStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(color: colorScheme.onTertiary);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onTertiaryFixedVariant,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl(
                groupValue: _groupValue,
                backgroundColor: colorScheme.tertiary,
                thumbColor: colorScheme.onTertiaryContainer,
                children: {
                  0: Text('Генерація', style: segmentTextStyle),
                  1: Text('Адаптація', style: segmentTextStyle),
                },
                onValueChanged: (value) =>
                    setState(() => _groupValue = value!),
              ),
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _groupValue == 0
                      ? GenerationOptions(
                          colorScheme: colorScheme,
                          userTopics: userTopics,
                          allHobbies: allHobbies,
                          onTopicChanged: (value) {
                            _selectedTopic = value;
                          },
                          onHobbyChanged: (value) {
                            _selectedHobby = value;
                          },
                        )
                      : AdaptationOptions(
                          colorScheme: colorScheme,
                          allHobbies: allHobbies,
                          onImageChanged: (value) {
                            _selectedImage = value;
                          },
                          onHobbyChanged: (value) {
                            _selectedHobby = value;
                          },
                        ),

                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: isSending ? () {} : _sendPrompt,
                        child: isSending
                            ? Text('Зачекайте...')
                            : Text('Надіслати'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
