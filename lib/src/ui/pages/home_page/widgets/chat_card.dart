import 'package:chat_verse/src/ui/pages/chat_page/chat_page.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final String? chatId;
  final String title;
  final String name;
  final String image;
  final String lastMessage;

  const ChatCard(
      {super.key,
      required this.name,
      required this.image,
      required this.lastMessage,
      this.chatId,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      shadowColor: Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        highlightColor: Theme.of(context).scaffoldBackgroundColor,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChatPage(
                chatId: chatId,
                title: title,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(offset: Offset(0, 0), blurRadius: 3, spreadRadius: -1)
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                image,
              ),
              minRadius: 30,
              maxRadius: 30,
            ),
            title: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              lastMessage.replaceAll("*", ""),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
