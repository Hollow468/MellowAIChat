import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller.dart';
import 'Controller.dart';
import 'Model.dart';

class PromptDialog extends StatefulWidget {
  const PromptDialog({Key? key}) : super(key: key);

  @override
  State<PromptDialog> createState() => _PromptDialogState();
}

class _PromptDialogState extends State<PromptDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController promptController = TextEditingController();
  bool showCreateForm = false;

  final PromptController controller = Get.put(PromptController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text("prompt_manage".tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              showCreateForm
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration:  InputDecoration(
                              hintText: "prompt_name".tr,
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: promptController,
                            maxLines: 3,
                            decoration:  InputDecoration(
                              hintText: "prompt_content".tr,
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    showCreateForm = false;
                                  });
                                },
                                child:  Text("cancel".tr),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  if (nameController.text.trim().isNotEmpty) {
                                    controller.addPrompt(
                                      PromptModel(
                                        name: nameController.text.trim(),
                                        prompt: promptController.text.trim(),
                                      ),
                                    );
                                    nameController.clear();
                                    promptController.clear();
                                    setState(() {
                                      showCreateForm = false;
                                    });
                                  }
                                },
                                child:  Text("save".tr),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                        label:  Text(
                          "create_new_prompt".tr,
                          style: TextStyle(color: Colors.blue),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            showCreateForm = true;
                          });
                        },
                      ),
                    ),
              const SizedBox(height: 24),

              Row(
                children: [
                   Text("my_prompt".tr, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Obx(() => Column(
                children: controller.prompts.map((prompt) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(prompt.name),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    onTap: () async {
                      final chatController = Get.find<ChatController>();
                      chatController.systemPrompt = prompt.prompt;
                      await chatController.saveSystemPrompt();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${'prompt_apply_success'.tr}：${prompt.name}')),
                      );
                    },
                  ),
                )).toList(),
              )),
              const SizedBox(height: 16),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child:  Text("cancel".tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
