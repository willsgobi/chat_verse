import 'package:chat_verse/src/ui/mixins/alert_mixin.dart';
import 'package:chat_verse/src/ui/pages/chat_page/blocs/chat_bloc.dart';
import 'package:chat_verse/src/ui/pages/chat_page/events/chat_event.dart';
import 'package:chat_verse/src/ui/pages/chat_page/widgets/chat_messages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  final String? chatId;
  final String? title;
  const ChatPage({super.key, this.chatId, required this.title});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with AlertDialogMixin {
  ValueNotifier<String> title = ValueNotifier("Nova conversa");
  ValueNotifier<String?> chatId = ValueNotifier<String?>(null);
  bool titleSaved = false;
  TextEditingController titleController = TextEditingController();

  showEditModal() {
    setState(() {
      titleSaved = false;
    });
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Editar"),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.edit),
                    hintText: "digite um título para essa conversa"),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    context.read<ChatBloc>().add(
                          ChangeChatTitle(
                              chatId: chatId.value!,
                              title: titleController.text),
                        );

                    if (title.value != titleController.text) {
                      setState(() {
                        titleSaved = true;
                      });
                    }

                    title.value = titleController.text;

                    Navigator.of(context).pop();
                  },
                  child: const Text("Atualizar"))
            ],
          ),
        );
      },
    ).whenComplete(
      () {
        if (titleController.text.isEmpty) {
          titleController.text = widget.title ?? title.value;
        } else {
          if (titleSaved) {
            title.value = titleController.text;
          }
        }
      },
    );
  }

  updateChatTitle(String? titleValue) {
    title.value = titleValue ?? "Conversa com IA";
    titleController.text = titleValue ?? "Conversa com IA";

    if (chatId.value != null) {
      context.read<ChatBloc>().add(
            ChangeChatTitle(
                chatId: chatId.value!, title: titleValue ?? "Conversa com IA"),
          );
    }
  }

  _deleteChat() {
    showAlertDialog(
      context: context,
      title: "Deseja excluir esse chat?",
      message:
          "Ao prosseguir, o chat será excluído e não será possível reverter essa ação!",
      onAccepted: () {
        if (chatId.value != null) {
          context.read<ChatBloc>().add(DeleteChat(chatId: chatId.value!));
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.title != null) {
      titleController.text = widget.title!;
      title.value = widget.title!;
    }

    chatId.value = widget.chatId;
  }

  @override
  void dispose() {
    title.dispose();
    chatId.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      extendBody: false,
      appBar: AppBar(
        centerTitle: true,
        title: ListenableBuilder(
          listenable: title,
          builder: (context, child) => Text(title.value),
        ),
        actions: [
          ListenableBuilder(
            listenable: chatId,
            builder: (context, child) {
              if (chatId.value == null) return const SizedBox();

              return IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteChat,
              );
            },
          ),
          ListenableBuilder(
            listenable: chatId,
            builder: (_, child) {
              return ListenableBuilder(
                listenable: title,
                builder: (_, child) {
                  if (chatId.value != null && title.value.isNotEmpty) {
                    return IconButton(
                      onPressed: showEditModal,
                      icon: const Icon(Icons.edit),
                    );
                  }

                  return const SizedBox();
                },
              );
            },
          )
        ],
      ),
      body: PopScope(
        canPop: true,
        onPopInvoked: (value) {
          context.read<ChatBloc>().add(GetChatsEvent());
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ChatMessagesList(
              chatId: chatId.value,
              updateChatId: (String id) {
                chatId.value = id;
              },
              updateChatTitle: (String? valueTitle) =>
                  updateChatTitle(valueTitle),
            ),
          ),
        ),
      ),
    );
  }
}
