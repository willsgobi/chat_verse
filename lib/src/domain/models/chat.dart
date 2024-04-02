import 'dart:convert';

import 'package:chat_verse/src/domain/models/message.dart';

class ChatModel {
  final String chatId;
  final String title;
  final String imageUrl;
  final List<Message> messages;
  final Message? lastMessage;

  ChatModel({
    required this.chatId,
    required this.title,
    required this.messages,
    required this.imageUrl,
    required this.lastMessage,
  });

  factory ChatModel.fromRawJson(String str) =>
      ChatModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
      chatId: json["chatId"],
      title: json["title"],
      imageUrl: json["imageUrl"],
      messages: List<Message>.from(
        json["messages"].map(
          (x) => Message.fromJson(x),
        ),
      ),
      lastMessage: List<Message>.from(
        json["messages"].map(
          (x) => Message.fromJson(x),
        ),
      ).first);

  Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "title": title,
        "imageUrl": imageUrl,
        "messages": List<dynamic>.from(
          messages.map(
            (x) => x.toJson(),
          ),
        ),
        "lastMessage": lastMessage
      };
}
