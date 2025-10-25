import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ModelInfo {
  final String id;
  final String object;
  final int created;
  final String ownedBy;
  ModelInfo({required this.id, required this.object, required this.created, required this.ownedBy});

  factory ModelInfo.fromJson(Map<String, dynamic> json) {
    return ModelInfo(
      id: json['id'] ?? '',
      object: json['object'] ?? '',
      created: json['created'] ?? 0,
      ownedBy: json['owned_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'object': object,
    'created': created,
    'owned_by': ownedBy,
  };
}

class SettingsModel extends GetxController {
  var models = <ModelInfo>[].obs;
  var loading = false.obs;
  var error = ''.obs;

  Future<void> fetchModels(String token) async {
    loading.value = true;
    error.value = '';
    try {
      final response = await http.get(
        Uri.parse('https://api.siliconflow.cn/v1/models'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<ModelInfo> list = (data['data'] as List)
            .map((e) => ModelInfo.fromJson(e))
            .toList();
        models.assignAll(list);
        await saveModelsToPrefs(list);
      } else {
        error.value = '请求失败: ${response.statusCode}';
      }
    } catch (e) {
      error.value = '请求异常: $e';
    } finally {
      loading.value = false;
    }
  }

  Future<void> saveModelsToPrefs(List<ModelInfo> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((m) => m.toJson()).toList();
    await prefs.setString('model_list', jsonEncode(jsonList));
  }

  Future<void> loadModelsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString('model_list');
    if (str != null && str.isNotEmpty) {
      try {
        final List data = jsonDecode(str);
        final List<ModelInfo> list = data.map((e) => ModelInfo.fromJson(e)).toList();
        models.assignAll(list);
      } catch (_) {}
    }
  }
}
