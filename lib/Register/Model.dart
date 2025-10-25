import "package:http/http.dart" as http;
import 'dart:convert';

class ReqService {
  static Future<http.Response> Register(String username,String email,String password)async{
    final response = await http.post(
        Uri.parse('http://api.huawii.com/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password
        })
    );
    return response;
  }
}