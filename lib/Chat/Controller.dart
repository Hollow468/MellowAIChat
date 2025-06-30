import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessage {
  final String role;
  final String content;
  ChatMessage({required this.role, required this.content});
}

class ChatController extends GetxController {
  var ask = TextEditingController();
  var messages = <ChatMessage>[].obs;
  String? systemPrompt;

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
}
