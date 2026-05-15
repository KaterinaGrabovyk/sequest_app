import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_up_app/Providers/user_data_provider.dart';
import 'package:skill_up_app/widgets/math_text_adapt.dart';

class DrawerItemDataScreen extends ConsumerWidget {
  const DrawerItemDataScreen({
    super.key,
    required this.title,
    required this.dbTitle,
  });
  final String title;
  final String dbTitle;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void openAddOverlay({Map<String, String>? item}) {
      showModalBottomSheet(
        context: context,
        builder: (ctx) => _AddItem(
          dbTitle: dbTitle,
          id: item?['id'],
          oldTitle: item?['title'],
        ),
        useSafeArea: true,
      );
    }

    final dataList = ref.watch(userDataProvider(dbTitle));
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          if (title != 'Задачі')
            IconButton(
              onPressed: openAddOverlay,
              icon: Icon(Icons.add),
            ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(),
        color: Theme.of(context).colorScheme.primary,
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: dataList.length,
          itemBuilder: (ctx, index) {
            return Dismissible(
              key: ValueKey(dataList[index]),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: title != 'Задачі'
                      ? Text('${dataList[index]['title']}')
                      : MarkdownBody(
                          data: '${dataList[index]['title']}',
                          inlineSyntaxes: [LatexSyntax()],
                          builders: {'latex': LatexBuilder()},
                        ),
                  trailing: title != 'Задачі'
                      ? IconButton(
                          icon: Icon(Icons.edit, size: 20),
                          onPressed: () =>
                              openAddOverlay(item: dataList[index]),
                        )
                      : null,
                ),
              ),
              onDismissed: (direction) {
                ref
                    .read(userDataProvider(dbTitle).notifier)
                    .deleteItem(dataList[index]['id']!);
              },
            );
          },
        ),
      ),
    );
  }
}

class _AddItem extends ConsumerStatefulWidget {
  const _AddItem({this.id, this.oldTitle, required this.dbTitle});
  final String? id;
  final String? oldTitle;
  final String dbTitle;
  @override
  ConsumerState<_AddItem> createState() {
    return _AddItemState();
  }
}

class _AddItemState extends ConsumerState<_AddItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredValue = '';

  void _submitData() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    _formKey.currentState!.save();
    if (widget.id != null) {
      ref
          .read(userDataProvider(widget.dbTitle).notifier)
          .editItem(widget.id!, _enteredValue);
    } else {
      ref
          .read(userDataProvider(widget.dbTitle).notifier)
          .addItem(_enteredValue);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: double.infinity,
      color: Theme.of(context).colorScheme.tertiary,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.id != null ? 'Редагувати' : 'Додати',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            TextFormField(
              initialValue: widget.oldTitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onTertiary,
              ),
              cursorColor: Theme.of(context).colorScheme.onTertiary,
              decoration: InputDecoration(
                counterStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
              ),
              maxLength: 60,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    value.trim().length < 3) {
                  return 'Має бути довше 3х символів';
                }
                return null;
              },
              onSaved: (value) {
                _enteredValue = value!;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: Text(
                widget.id != null ? 'Зберегти' : 'Додати',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
