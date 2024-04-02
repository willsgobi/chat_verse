import 'dart:io';

import 'package:chat_verse/src/ui/pages/chat_page/blocs/message_bloc.dart';
import 'package:chat_verse/src/ui/pages/chat_page/events/message_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMessageWidget extends StatefulWidget {
  final String? chatId;
  const SendMessageWidget({super.key, this.chatId});

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  TextEditingController messageController = TextEditingController();

  Future sendMessage() async {
    if (messageController.text.isNotEmpty) {
      context.read<MessageBloc>().add(
            SendMessageEvent(
              widget.chatId,
              message: messageController.text,
              localUser: true,
            ),
          );
      messageController.text = '';
    }
  }

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: KeyboardListener(
              focusNode: FocusNode(
                onKeyEvent: (node, event) {
                  if (HardwareKeyboard.instance
                      .isLogicalKeyPressed(LogicalKeyboardKey.enter)) {
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
              ),
              onKeyEvent: (event) {
                if (HardwareKeyboard.instance
                    .isLogicalKeyPressed(LogicalKeyboardKey.enter)) {
                  if (Platform.isWindows) {
                    sendMessage();
                  }
                }
              },
              child: TextField(
                controller: messageController,
                minLines: 1,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Digite sua mensagem",
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(30, 50)),
              onPressed: sendMessage,
              child: const Icon(Icons.send))
        ],
      ),
    );
  }
}
