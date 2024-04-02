abstract class ChatEvent {}

class GetChatsEvent extends ChatEvent {}

class GetCurrentChatEvent extends ChatEvent {
  final String chatId;

  GetCurrentChatEvent({required this.chatId});
}

class ChangeChatTitle extends ChatEvent {
  final String chatId;
  final String title;

  ChangeChatTitle({required this.chatId, required this.title});
}

class DeleteChat extends ChatEvent {
  final String chatId;

  DeleteChat({required this.chatId});
}
