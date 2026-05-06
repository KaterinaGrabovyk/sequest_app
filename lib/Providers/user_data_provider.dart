import 'package:flutter_riverpod/legacy.dart';
import 'package:localstore/localstore.dart';

class UserDataProvider
    extends StateNotifier<List<Map<String, String>>> {
  UserDataProvider(this.dbTitle) : super([]) {
    _loadData();
  }
  final String dbTitle;
  final _db = Localstore.instance;
  Future<void> _loadData() async {
    final items = await _db.collection(dbTitle).get();
    if (items != null) {
      final List<Map<String, String>> loadedData = items.values.map(
        (item) {
          return {
            'id': item['id'] as String,
            'title': item['title'] as String,
            'createdAt': item['createdAt'] as String,
          };
        },
      ).toList();
      loadedData.sort(
        (a, b) => b['createdAt']!.compareTo(a['createdAt']!),
      );
      state = loadedData;
    }
  }

  void addItem(String title) {
    final id = _db.collection(dbTitle).doc().id;
    final newItem = {
      'id': id,
      'title': title,
      'createdAt': DateTime.now().toIso8601String(),
    };

    _db.collection(dbTitle).doc(id).set(newItem);

    state = [newItem, ...state];
  }

  void editItem(String id, String newTitle) {
    final existingItem = state.firstWhere(
      (item) => item['id'] == id,
    );
    final updatedItem = {
      'id': id,
      'title': newTitle,
      'createdAt': existingItem['createdAt']!,
    };
    _db.collection(dbTitle).doc(id).set(updatedItem);
    state = [
      for (final item in state)
        if (item['id'] == id) updatedItem else item,
    ];
  }

  void deleteItem(String id) {
    _db.collection(dbTitle).doc(id).delete();
    state = state.where((item) => item['id'] != id).toList();
  }
}

final userDataProvider =
    StateNotifierProvider.family<
      UserDataProvider,
      List<Map<String, String>>,
      String
    >((ref, dbTitle) => UserDataProvider(dbTitle));
