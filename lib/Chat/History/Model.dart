class ChatHistory {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<Map<String, String>> messages;

  ChatHistory({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      messages: (json['messages'] as List)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'createdAt': createdAt.toIso8601String(),
    'messages': messages,
  };
}
