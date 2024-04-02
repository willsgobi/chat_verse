import 'package:chat_verse/src/domain/models/message.dart';

abstract class MessageState {}

class InitialMessageState extends MessageState {}

class LoadedMessagesState extends MessageState {
  final List<Message>? messages;

  LoadedMessagesState({required this.messages});
}

class SendingMessageState extends MessageState {}

class ErrorMessageState extends MessageState {
  final String errorMessage;

  ErrorMessageState({required this.errorMessage});
}

class MessageSentEvent extends MessageState {
  final String chatId;

  MessageSentEvent({required this.chatId});
}

class OnNewMessageState extends MessageState {
  final Message? message;
  final String chatId;

  OnNewMessageState(this.chatId, {required this.message});
}

class AiLoadingMessageState extends MessageState {}

class TitleMessageState extends MessageState {
  final String title;

  TitleMessageState({required this.title});
}
