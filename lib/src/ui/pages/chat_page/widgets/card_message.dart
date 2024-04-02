import 'package:chat_verse/src/domain/enums/message_from.dart';
import 'package:chat_verse/src/domain/models/message.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  final bool isEmpty;
  final Message message;

  const MessageCard({super.key, required this.message, required this.isEmpty});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  List<TextSpan> parseText(String text) {
    List<TextSpan> spans = [];
    final lines = text.split('\n');
    for (var line in lines) {
      if (line.startsWith('* ')) {
        spans.add(const TextSpan(
            text: '• ', style: TextStyle(fontWeight: FontWeight.normal)));
        line = line.substring(2);
      }
      final words = line.split('*');
      for (var i = 0; i < words.length; i++) {
        spans.add(TextSpan(
          text: words[i],
          style: words[i].endsWith(':')
              ? const TextStyle(fontWeight: FontWeight.bold)
              : const TextStyle(fontWeight: FontWeight.normal),
        ));
      }
      spans.add(const TextSpan(text: '\n'));
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    bool isLocalMessage =
        widget.message.from == MessageFrom.localUser.toString();
    bool isErrorMessage =
        widget.message.from == MessageFrom.errorMessage.toString();

    Alignment alignment =
        isLocalMessage ? Alignment.centerRight : Alignment.centerLeft;

    if (widget.isEmpty) {
      return const Text("Nenhuma mensagem enviada");
    }

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 2,
              spreadRadius: -1,
            )
          ],
          color: isErrorMessage
              ? Colors.red
              : isLocalMessage
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Colors.deepPurple,
        ),
        constraints: BoxConstraints(
          minWidth: 100,
          maxWidth: MediaQuery.of(context).size.width / 1.4,
        ),
        child: Wrap(
          children: [
            SelectableText.rich(
              TextSpan(
                children: parseText(widget.message.message),
                style: TextStyle(
                  color: isLocalMessage
                      ? Theme.of(context).brightness.name == "dark"
                          ? Colors.white
                          : Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
