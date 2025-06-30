import 'package:flutter/material.dart';
import 'package:mellowai/Chat/Setting/Controller.dart';
import 'package:get/get.dart';
import 'Model.dart';

class Settings extends StatefulWidget {
  Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final SettingsController settingsController = Get.put(SettingsController());
  final SettingsModel settingsModel = Get.put(SettingsModel());
  final TextEditingController tokenController = TextEditingController();
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    settingsController.LoadConfig().then((_) {
      tokenController.text = settingsController.apitoken.value;
      setState(() {
        isLoaded = true;
      });
      // 自动拉取模型列表
      settingsModel.fetchModels(settingsController.apitoken.value);
    });
  }

  @override
  void dispose() {
    tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.9;
    final maxHeight = MediaQuery.of(context).size.height * 0.8;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        ),
        child: DefaultTabController(
          length: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              Text('settings'.tr, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
               TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: 'model'.tr),
                  Tab(text: 'display'.tr),
                  Tab(text: 'chat'.tr),
                ],
              ),
              Expanded(
                child: isLoaded
                    ? TabBarView(
                        children: [
                          // 第一个
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const SizedBox(height: 24),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('api_url'.tr, style: TextStyle(fontSize: 16)),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: 'deepseek-ai/DeepSeek-V3',
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'deepseek-ai/DeepSeek-V3',
                                          child: Text('Siliconflow')),
                                    ],
                                    onChanged: (v) {},
                                    decoration: const InputDecoration(border: OutlineInputBorder()),
                                  ),
                                ),
                                const SizedBox(height: 16),
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
                                const SizedBox(height: 24),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('context_limit'.tr, style: TextStyle(fontSize: 16)),
                                ),
                                Obx(() => Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value: settingsController.contextLimit.value.toDouble(),
                                        min: 1,
                                        max: 50,
                                        divisions: 49,
                                        label: settingsController.contextLimit.value.toString(),
                                        onChanged: (v) => settingsController.contextLimit.value = v.toInt(),
                                      ),
                                    ),
                                    Text('${settingsController.contextLimit.value}'),
                                  ],
                                )),
                              ],
                            ),
                          ),
                          // 第二个
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // 语言切换选择框
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('language'.tr, style: TextStyle(fontSize: 16)),
                                ),
                                const SizedBox(height: 8),
                                Obx(() => DropdownButtonFormField<Locale>(
                                  isExpanded: true,
                                  value: settingsController.locale.value,
                                  items: const [
                                    DropdownMenuItem(
                                      value: Locale('zh', 'CN'),
                                      child: Text('简体中文'),
                                    ),
                                    DropdownMenuItem(
                                      value: Locale('en', 'US'),
                                      child: Text('English'),
                                    ),
                                  ],
                                  onChanged: (v) async {
                                    if (v != null) {
                                      settingsController.locale.value = v;
                                      Get.updateLocale(v);
                                      await settingsController.SaveConfig();
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
                                  icon: const Icon(Icons.language, size: 24),
                                  itemHeight: 48,
                                  borderRadius: BorderRadius.circular(12),
                                  menuMaxHeight: 160,
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                                )),
                              ],
                            ),
                          ),
                          // 第三个
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [],
                            ),
                          ),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child:  Text('cancel'.tr),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        settingsController.apitoken.value = tokenController.text;
                        await settingsController.SaveConfig();
                        Navigator.of(context).pop();
                      },
                      child:  Text('save'.tr),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}