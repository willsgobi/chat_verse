import 'package:chat_verse/src/ui/pages/chat_page/blocs/chat_bloc.dart';
import 'package:chat_verse/src/ui/pages/chat_page/chat_page.dart';
import 'package:chat_verse/src/ui/pages/chat_page/events/chat_event.dart';
import 'package:chat_verse/src/ui/pages/chat_page/states/chat_state.dart';
import 'package:chat_verse/src/ui/pages/home_page/drawer.dart';
import 'package:chat_verse/src/ui/pages/home_page/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  updateChatsOnScreen() {
    context.read<ChatBloc>().add(GetChatsEvent());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChatBloc>().add(GetChatsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatVerse"),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
              onPressed: updateChatsOnScreen, icon: const Icon(Icons.refresh))
        ],
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Últimas conversas",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocConsumer<ChatBloc, ChatState>(
                builder: (_, state) {
                  if (state is LoadingChatState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is LoadedChatListState) {
                    if (state.chats.isEmpty) {
                      return const Center(
                        child: Text("Nenhuma mensagem encontrada."),
                      );
                    }

                    return SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: state.chats
                              .map((e) => ChatCard(
                                  chatId: e.chatId,
                                  title: e.title,
                                  name: e.chatId,
                                  image: e.imageUrl,
                                  lastMessage: e.lastMessage?.message ?? ""))
                              .toList(),
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: Text("Não foi possível obter as mensagens"),
                  );
                },
                listener: (BuildContext context, ChatState state) {
                  if (state is ChatDeletedState) {
                    setState(() {
                      updateChatsOnScreen();
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ChatPage(
                title: null,
              ),
            ),
          );
        },
        label: const Text("Nova conversa"),
      ),
    );
  }
}
