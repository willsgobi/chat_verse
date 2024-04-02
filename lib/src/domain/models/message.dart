import 'dart:convert';

class Message {
  final String from;
  final String message;
  final String sentAt;

  Message({
    required this.from,
    required this.message,
    required this.sentAt,
  });

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        from: json["from"],
        message: json["message"],
        sentAt: json["sentAt"],
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "message": message,
        "sentAt": sentAt,
      };
}
