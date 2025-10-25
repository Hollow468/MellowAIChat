import 'package:flutter/material.dart';
import 'package:mellowai/Login/Controller.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9F6),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  'welcome'.tr,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B5B8C),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'login_to_continue'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF7B7BA5),
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: controller.email,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0x80F6F6F6),
                    hintText: 'email'.tr,
                    hintStyle: TextStyle(color: Color(0xFFB8B8D1)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.passwd,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0x80F6F6F6),
                    hintText: 'password'.tr,
                    hintStyle: TextStyle(color: Color(0xFFB8B8D1)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B5B8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                    ),
                    onPressed: (){controller.login();},
                    child: Text(
                      'login'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child:  Text(
                      'forget_password'.tr,
                      style: TextStyle(
                        color: Color(0xFFB0B0D0),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),


                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      'is_no_account'.tr,
                      style: TextStyle(
                        color: Color(0xFFB0B0D0),
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {Get.offNamed('/signup');},
                      child:  Text(
                        'sign_up'.tr,
                        style: TextStyle(
                          color: Color(0xFF5B5B8C),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
