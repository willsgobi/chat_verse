import 'package:chat_verse/src/domain/models/chat.dart';

abstract class ChatState {}

class InitialChatState extends ChatState {}

class LoadingChatState extends ChatState {}

class LoadedChatListState extends ChatState {
  final List<ChatModel> chats;

  LoadedChatListState({required this.chats});
}

class LoadedChatState extends ChatState {
  final ChatModel chat;

  LoadedChatState({required this.chat});
}

class ChatDeletedState extends ChatState {}

class ErrorChatState extends ChatState {
  final String errorMessage;

  ErrorChatState({required this.errorMessage});
}
