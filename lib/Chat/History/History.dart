import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controller.dart';
import 'Model.dart';
import 'package:mellowai/Chat/Controller.dart';

class HistoryDrawer extends StatelessWidget {
  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    final chatController = Get.find<ChatController>();
    return Drawer(
      width: width,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      chatController.messages.clear();
                      chatController.currentHistoryId = null;
                      final newHistory = ChatHistory(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: 'new_chat'.tr,
                        createdAt: DateTime.now(),
                        messages: [],
                      );
                      controller.addHistory(newHistory);
                      chatController.loadFromHistory(newHistory);
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.add),
                    label: Text('open_new_chat'.tr),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.histories.length,
                itemBuilder: (context, index) {
                  final history = controller.histories[index];
                  final isCurrent = chatController.currentHistoryId == history.id;
                  return ListTile(
                    title: Text(history.title),
                    subtitle: Text(
                      history.createdAt.toString().substring(0, 19),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    selected: isCurrent,
                    selectedTileColor: Colors.blue[50],
                    onTap: () {
                      chatController.loadFromHistory(history);
                      Navigator.of(context).pop();
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => controller.deleteHistory(history.id),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
