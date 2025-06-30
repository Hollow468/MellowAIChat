import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Controller.dart';

class ChatApi {
  static Future<String> sendChatRequest({required String apitoken, required String model, required String content}) async {
    if (apitoken.isEmpty || content.isEmpty) {
      return 'Token或消息内容不能为空';
    }
    final url = Uri.parse('https://api.siliconflow.cn/v1/chat/completions');
    final headers = {
      'Authorization': 'Bearer ' + apitoken,
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "model": model,
      "messages": [
        {
          "role": "user",
          "content": content,
        }
      ]
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return '请求失败: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return '请求异常: $e';
    }
  }

  static Stream<ChatMessage> sendChatRequestStream({
    required String token,
    required String model,
    required String content,
    List<Map<String, String>>? messages,
    bool stream = true,
    int maxTokens = 512,
    bool enableThinking = true,
    int thinkingBudget = 4096,
    double minP = 0.05,
    double temperature = 0.7,
    double topP = 0.7,
    int topK = 50,
    double frequencyPenalty = 0.5,
    int n = 1,
    List<dynamic> stop = const [],
  }) async* {
    if (token.isEmpty || (content.isEmpty && (messages == null || messages.isEmpty))) {
      yield ChatMessage(role: 'error', content: 'Token或消息内容不能为空');
      return;
    }
    final url = Uri.parse('https://api.siliconflow.cn/v1/chat/completions');
    final headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "model": model,
      "stream": stream,
      "max_tokens": maxTokens,
      "enable_thinking": enableThinking,
      "thinking_budget": thinkingBudget,
      "min_p": minP,
      "temperature": temperature,
      "top_p": topP,
      "top_k": topK,
      "frequency_penalty": frequencyPenalty,
      "n": n,
      "stop": stop,
      "messages": messages ?? [
        {
          "role": "user",
          "content": content,
        }
      ]
    });
    try {
      final request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = body;
      final response = await request.send();
      if (response.statusCode == 200) {
        await for (var line in response.stream.transform(utf8.decoder)) {
          for (var part in line.split('\n')) {
            if (part.trim().isEmpty || !part.trim().startsWith('data:')) continue;
            final jsonStr = part.trim().substring(5).trim();
            if (jsonStr == '[DONE]') break;
            try {
              final data = jsonDecode(jsonStr);
              final content = data['choices']?[0]?['delta']?['content'] ?? '';
              if (content.isNotEmpty) {
                yield ChatMessage(role: 'assistant', content: content);
              }
            } catch (_) {}
          }
        }
      } else {
        yield ChatMessage(role: 'error', content: '请求失败: ${response.statusCode}');
      }
    } catch (e) {
      yield ChatMessage(role: 'error', content: '请求异常: $e');
    }
  }
}
