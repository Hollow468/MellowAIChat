import 'package:flutter/material.dart';
import 'package:mellowai/Chat/Setting/Controller.dart';
import 'package:get/get.dart';
import 'Model.dart';
import 'package:mellowai/Chat/ApiProvide.dart';

class Settings extends StatefulWidget {
  Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final SettingsController settingsController = Get.put(SettingsController());
  final SettingsModel settingsModel = Get.put(SettingsModel());
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    settingsController.LoadConfig().then((_) {
      setState(() {
        isLoaded = true;
      });
      // 自动拉取模型列表
      settingsModel.fetchModels(settingsController.apitoken.value);
    });
  }

  @override
  void dispose() {
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
                                Obx(() {
                                  return DropdownButtonFormField<ApiProvider>(
                                    value: settingsController.provider.value,
                                    items: ApiProvider.values.map((provider) {
                                      return DropdownMenuItem(
                                        value: provider,
                                        child: Text(apiProviderNames[provider]!),
                                      );
                                    }).toList(),
                                    onChanged: (value) async {
                                      if (value != null) {
                                        settingsController.provider.value = value;
                                        await settingsController.SaveConfig();
                                        setState(() {});
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'API提供者',
                                      border: OutlineInputBorder(),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 16),

                                Obx(() {
                                  return settingsController.GetProvideSettings();
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