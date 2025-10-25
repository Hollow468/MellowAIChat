import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mellowai/Register/Controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final Register controller = Get.put(Register());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9F6),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                 Text(
                  'register'.tr,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B5B8C),
                  ),
                ),
                const SizedBox(height: 48),
                _buildTextField(hint: 'name'.tr,controller: controller.username),
                const SizedBox(height: 16),
                _buildTextField(hint: 'email'.tr,controller: controller.email),
                const SizedBox(height: 16),
                _buildTextField(hint: 'password'.tr, obscure: true,controller: controller.passwd),
                const SizedBox(height: 16),
                _buildTextField(hint: 'confirm_password'.tr, obscure: true,controller: controller.cpasswd),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B5B8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {controller.Verity();},
                    child:  Text(
                      'subscribe'.tr,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      'do_you_have_account'.tr,
                      style: TextStyle(
                        color: Color(0xFF7B7BA5),
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {Get.offNamed('/login');},
                      child:  Text(
                        'log_in'.tr,
                        style: TextStyle(
                          color: Color(0xFF5B5B8C),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, bool obscure = false, required TextEditingController controller}) {
    return TextField(
      obscureText: obscure,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB8B8D1)),
        filled: true,
        fillColor: Colors.white.withAlpha(70),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
