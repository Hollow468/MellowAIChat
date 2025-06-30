import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'Model.dart';

class PromptController extends GetxController {
  final RxList<PromptModel> prompts = <PromptModel>[].obs;
  final box = GetStorage();
  final String storageKey = 'prompts';

  @override
  void onInit() {
    super.onInit();
    loadPrompts();
  }

  void loadPrompts() {
    final List<dynamic>? data = box.read(storageKey);
    if (data != null) {
      prompts.assignAll(data.map((e) => PromptModel.fromJson(e)).toList());
    }
  }

  void addPrompt(PromptModel prompt) {
    prompts.add(prompt);
    savePrompts();
  }

  void savePrompts() {
    box.write(storageKey, prompts.map((e) => e.toJson()).toList());
  }
}