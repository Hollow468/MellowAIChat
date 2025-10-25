import 'dart:convert';

import 'package:flutter/material.dart';
import 'Model.dart';
import 'package:get/get.dart';



class Register extends GetxController {
  final username = TextEditingController();
  final email = TextEditingController();
  final passwd = TextEditingController();
  final cpasswd = TextEditingController();
var isLoading = false.obs;

  Future<void> Verity() async {
    if (passwd.text != cpasswd.text) {
      Get.snackbar('Error', 'Passwords do not match',duration: Duration(seconds: 1),backgroundColor: Color(0xFFDFE0EF));
      return;
    }
    await register();
  }

  Future<void> register() async {
    isLoading.value = true;
    final response = await ReqService.Register(username.text,email.text, passwd.text);
    isLoading.value = false;
    if (response.statusCode == 200) {

    } else {
      final Map<String,dynamic> data = jsonDecode(response.body);
      String msg = data['message'] ?? 'Register failed';
      Get.snackbar('Result', msg,duration: Duration(seconds: 1),backgroundColor: Color(0xFFDFE0EF));
    }
  }


}