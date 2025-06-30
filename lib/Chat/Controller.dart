import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'History/Model.dart';
import 'History/Controller.dart';
import 'Setting/Controller.dart';
import 'Model.dart';

class ChatMessage {
  final String role;
  final String content;
  ChatMessage({required this.role, required this.content});
}

class ChatController extends GetxController {
  var ask = TextEditingController();
  var messages = <ChatMessage>[].obs;
  String? systemPrompt;
  String? currentHistoryId;

  @override
  void onInit() {
    super.onInit();
    loadSystemPrompt();
  }

  Future<void> loadSystemPrompt() async {
    final pref = await SharedPreferences.getInstance();
    systemPrompt = pref.getString('systemPrompt');
  }

  Future<void> saveSystemPrompt() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('systemPrompt', systemPrompt ?? '');
  }

  void loadFromHistory(ChatHistory history) {
    messages.assignAll(history.messages.map((m) =>
      ChatMessage(role: m['role'] ?? '', content: m['content'] ?? '')
    ));
    currentHistoryId = history.id;
  }

  ChatHistory toHistory() {
    return ChatHistory(
      id: currentHistoryId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: messages.isNotEmpty
          ? messages.first.content.substring(0, messages.first.content.length > 10 ? 10 : messages.first.content.length)
          : '新会话',
      createdAt: DateTime.now(),
      messages: messages.map((m) => {'role': m.role, 'content': m.content}).toList(),
    );
  }

  Future<void> loadLastSession() async {
    final historyController = Get.find<HistoryController>();
    await historyController.loadHistories();
    if (historyController.histories.isNotEmpty) {
      loadFromHistory(historyController.histories[0]);
    }
  }

  Future<void> handleSendAndSaveHistory(SettingsController settingsController) async {
    final token = settingsController.apitoken.value;
    final model = settingsController.model.value.isNotEmpty
        ? settingsController.model.value
        : "Qwen/Qwen2.5-VL-72B-Instruct";
    final content = ask.text.trim();
    if (content.isEmpty) return;

    messages.add(ChatMessage(role: 'user', content: content));
    ask.clear();

    // 固定上下文条数限制为20
    final contextMessages = <Map<String, String>>[];
    // 插入system prompt
    contextMessages.add({
      'role': 'system',
      'content': systemPrompt?.isNotEmpty == true ? systemPrompt! : 'You are helpful assistant',
    });
    final history = messages.length > 20
        ? messages.sublist(messages.length - 20)
        : List<ChatMessage>.from(messages);
    for (final msg in history) {
      contextMessages.add({
        'role': msg.role,
        'content': msg.content,
      });
    }
    contextMessages.add({'role': 'user', 'content': content});

    messages.add(ChatMessage(role: 'assistant', content: ''));
    int aiIndex = messages.length - 1;
    String aiContent = '';

    await for (final msg in ChatApi.sendChatRequestStream(
      token: token,
      model: model,
      content: '',
      messages: contextMessages,
      stream: true,
      maxTokens: 512,
      enableThinking: true,
      thinkingBudget: 4096,
      minP: 0.05,
      temperature: 0.7,
      topP: 0.7,
      topK: 50,
      frequencyPenalty: 0.5,
      n: 1,
      stop: const [],
    )) {
      if (msg.role == 'assistant') {
        aiContent += msg.content;
        messages[aiIndex] = ChatMessage(role: 'assistant', content: aiContent);
        messages.refresh();
      }
    }

    // 自动保存到当前会话
    final historyController = HistoryController.to;
    if (currentHistoryId != null) {
      historyController.updateHistory(toHistory());
    } else {
      final newHistory = toHistory();
      historyController.addHistory(newHistory);
      currentHistoryId = newHistory.id;
    }
  }
}
