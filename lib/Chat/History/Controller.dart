import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Model.dart';

class HistoryController extends GetxController {
  static HistoryController get to => Get.find<HistoryController>();
  var histories = <ChatHistory>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistories();
  }

  Future<void> loadHistories() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('chat_histories');
    if (data != null) {
      final list = jsonDecode(data) as List;
      histories.assignAll(list.map((e) => ChatHistory.fromJson(e)).toList());
    }
  }

  Future<void> saveHistories() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('chat_histories', jsonEncode(histories.map((e) => e.toJson()).toList()));
  }

  void addHistory(ChatHistory history) {
    histories.insert(0, history);
    saveHistories();
  }

  void updateHistory(ChatHistory history) {
    final idx = histories.indexWhere((h) => h.id == history.id);
    if (idx != -1) {
      histories[idx] = history;
      saveHistories();
    }
  }

  void deleteHistory(String id) {
    histories.removeWhere((h) => h.id == id);
    saveHistories();
  }
}
