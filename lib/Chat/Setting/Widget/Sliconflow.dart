import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mellowai/Chat/Setting/Controller.dart';
import 'package:mellowai/Chat/Setting/Model.dart';

class SiliconflowSettingsWidget extends StatelessWidget {
  final SettingsController controller;
  final TextEditingController tokenController = TextEditingController();
  final SettingsController settingsController = Get.put(SettingsController());
  final SettingsModel settingsModel = Get.put(SettingsModel());


  SiliconflowSettingsWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('api_token'.tr, style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: tokenController,
          obscureText: true,
          onChanged: (v) => settingsController.apitoken.value = v,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.visibility),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('model'.tr, style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final modelList = settingsModel.models;
          final value = modelList.any((m) => m.id == settingsController.model.value)
              ? settingsController.model.value
              : null;
          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: value,
            items: modelList.isEmpty
                ? const [
              DropdownMenuItem(
                value: 'deepseek-ai/DeepSeek-V3',
                child: Text('deepseek-ai/DeepSeek-V3'),
              )
            ]
                : modelList
                .map((m) => DropdownMenuItem(
              value: m.id,
              child: Text(
                m.id,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ))
                .toList(),
            onChanged: (v) => settingsController.model.value = v ?? '',
            onTap: () async {
              await settingsModel.fetchModels(settingsController.apitoken.value);
              if (settingsModel.error.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title:  Text('connect_test_failed'.tr),
                    content: Text(settingsModel.error.value),
                    actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('确定'))],
                  ),
                );
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            dropdownColor: Colors.white,
            icon: const Icon(Icons.arrow_drop_down, size: 28),
            itemHeight: 48,
            borderRadius: BorderRadius.circular(12),
            menuMaxHeight: 320,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          );
        }),
      ],
    );
  }
}