import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'History/Controller.dart';
import 'History/History.dart';
import 'Menu/Menu.dart' as menu;
import 'Controller.dart';
import 'Setting/Controller.dart';
import 'Model.dart';


class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final menu.MenuController menuController = Get.put(menu.MenuController());
  final ChatController chatController = Get.put(ChatController());
  final SettingsController settingsController = Get.put(SettingsController());

  Future<void> handleSend() async {
    await chatController.handleSendAndSaveHistory(settingsController);
  }

  @override
  Widget build(BuildContext context) {

    Future.microtask(() => chatController.loadLastSession());
    return Scaffold(
      drawer: HistoryDrawer(),
      drawerEdgeDragWidth: 30,
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black87),
          onPressed: () => menuController.showMenu(context),
        ),
        title: Obx(() => Text(
          settingsController.model.value.isNotEmpty
              ? settingsController.model.value
              : 'MellowAi',
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        )),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: chatController.messages.length,
              itemBuilder: (context, index) {
                final msg = chatController.messages[index];
                final isUser = msg.role == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg.content),
                  ),
                );
              },
            )),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: chatController.ask,
                        decoration: InputDecoration(
                          hintText: 'ask_anything'.tr,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: const Color(0xFF7C4DFF),
                    shape: const CircleBorder(),
                    elevation: 4,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: handleSend,
                      child: const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Icon(Icons.send, color: Colors.white, size: 26),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
