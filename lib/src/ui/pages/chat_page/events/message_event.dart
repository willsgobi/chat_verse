abstract class MessageEvent {}

class GetCurrentChatMessagesEvent extends MessageEvent {
  final String chatId;

  GetCurrentChatMessagesEvent({required this.chatId});
}

class SendMessageEvent extends MessageEvent {
  final String message;
  final bool localUser;
  final String? chatId;

  SendMessageEvent(this.chatId,
      {required this.message, required this.localUser});
}

class OnNewMessageEvent extends MessageEvent {}
