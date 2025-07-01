import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mellowai/Chat/Setting/Controller.dart';
import 'package:mellowai/Chat/Setting/Model.dart';

class GeminiSettingsWidget extends StatelessWidget {
  final SettingsController controller;
  final TextEditingController tokenController = TextEditingController();
  final SettingsController settingsController = Get.put(SettingsController());
  final SettingsModel settingsModel = Get.put(SettingsModel());


  GeminiSettingsWidget({required this.controller});

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





      ],
    );
  }
}