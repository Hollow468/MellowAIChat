import 'package:flutter/material.dart';
import 'Model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

  Future<void> Token(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

class LoginController extends GetxController {
  final email = TextEditingController();
  final passwd = TextEditingController();
  var isLoading = false.obs;

  Future<void> login() async {
    isLoading.value = true;
    final response = await ReqService.login(email.text, passwd.text);
    isLoading.value = false;
    if (response.statusCode == 200) {
      Get.offAllNamed('/chat');
    } else {
      Get.snackbar('Error', 'Login failed',duration: Duration(seconds: 1),backgroundColor: Color(0xFFDFE0EF));
    }
  }


}