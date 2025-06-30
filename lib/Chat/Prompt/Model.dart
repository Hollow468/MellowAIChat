import 'package:get/get.dart';

class PromptModel {
  String name;
  String prompt;

  PromptModel({required this.name, required this.prompt});

  factory PromptModel.fromJson(Map<String, dynamic> json) {
    return PromptModel(
      name: json['name'] ?? '',
      prompt: json['prompt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'prompt': prompt,
  };
}