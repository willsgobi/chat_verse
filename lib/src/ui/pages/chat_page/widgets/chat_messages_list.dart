import 'package:chat_verse/src/domain/models/message.dart';
import 'package:chat_verse/src/ui/pages/chat_page/blocs/message_bloc.dart';
import 'package:chat_verse/src/ui/pages/chat_page/events/message_event.dart';
import 'package:chat_verse/src/ui/pages/chat_page/states/message_state.dart';
import 'package:chat_verse/src/ui/pages/chat_page/widgets/card_message.dart';
import 'package:chat_verse/src/ui/pages/chat_page/widgets/write_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessagesList extends StatefulWidget {
  final String? chatId;
  final Function(String chatId) updateChatId;
  final Function(String? title) updateChatTitle;
  const ChatMessagesList(
      {super.key,
      required this.chatId,
      required this.updateChatId,
      required this.updateChatTitle});

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<List<Message>> messages = ValueNotifier<List<Message>>([]);
  ValueNotifier<String?> chatId = ValueNotifier<String?>(null);
  ValueNotifier<bool> aiWriting = ValueNotifier<bool>(false);
  ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  updateChatId(String valueChatId) {
    chatId.value = valueChatId;
    widget.updateChatId(valueChatId);
  }

  _scrollList() {
    if (messages.value.length > 1 && _scrollController.positions.isNotEmpty) {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.chatId != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          context.read<MessageBloc>().add(
                GetCurrentChatMessagesEvent(chatId: widget.chatId!),
              );
        },
      );
      chatId.value = widget.chatId;
    }

    messages.addListener(() {
      _scrollList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    errorMessage.dispose();
    aiWriting.dispose();
    chatId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height - 100,
      width: MediaQuery.sizeOf(context).width,
      child: ListView(
        shrinkWrap: true,
        children: [
          BlocListener<MessageBloc, MessageState>(
            listener: (_, state) {
              if (state is LoadedMessagesState) {
                messages.value = List.from(state.messages ?? []);
                Future.delayed(const Duration(milliseconds: 100)).then(
                  (value) => _scrollList(),
                );
              }

              if (state is AiLoadingMessageState) {
                aiWriting.value = true;
              }

              if (state is OnNewMessageState) {
                if (state.message != null) {
                  messages.value = List.from(messages.value)
                    ..insert(0, state.message!);
                  updateChatId(state.chatId);
                  aiWriting.value = false;
                }
              }

              if (state is TitleMessageState) {
                widget.updateChatTitle(state.title);
              }

              if (state is ErrorMessageState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            child: ListenableBuilder(
              listenable: messages,
              builder: (context, child) {
                return SizedBox(
                  height: MediaQuery.sizeOf(context).height / 1.25,
                  width: MediaQuery.sizeOf(context).width,
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: messages.value.length,
                    itemBuilder: (context, index) {
                      if (chatId.value == null || messages.value.isEmpty) {
                        return const Text(
                          "Nenhuma mensagem enviada.",
                          textAlign: TextAlign.center,
                        );
                      }

                      return MessageCard(
                        message: messages.value[index],
                        isEmpty: chatId.value == null,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          ListenableBuilder(
            listenable: aiWriting,
            builder: (context, child) {
              if (aiWriting.value) {
                return const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "digitando mensagem...",
                    textAlign: TextAlign.start,
                  ),
                );
              }

              return ListenableBuilder(
                listenable: chatId,
                builder: (context, child) {
                  return SendMessageWidget(chatId: chatId.value);
                },
              );
            },
          )
        ],
      ),
    );
  }
}
