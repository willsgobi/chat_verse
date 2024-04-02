import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_verse/src/core/providers/i_ai_provider.dart';
import 'package:chat_verse/src/data/services/chat_service.dart';
import 'package:chat_verse/src/domain/enums/message_from.dart';
import 'package:chat_verse/src/domain/models/message.dart';
import 'package:chat_verse/src/ui/pages/chat_page/events/message_event.dart';
import 'package:chat_verse/src/ui/pages/chat_page/states/message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final IAiProvider _aiProvider;
  final ChatService _chatService;

  MessageBloc(this._chatService, this._aiProvider)
      : super(InitialMessageState()) {
    on(_mapEventToState);
  }

  Future<String?> requestReponseAi(String message) async {
    final String messageTitle = message;
    final messageResponse = await _aiProvider.sendPrompt(messageTitle);

    return messageResponse;
  }

  Future _mapEventToState(
      MessageEvent event, Emitter<MessageState> emit) async {
    if (event is GetCurrentChatMessagesEvent) {
      final chat = await _chatService.getChat(event.chatId);
      emit(LoadedMessagesState(messages: chat.messages));
    }

    if (event is SendMessageEvent) {
      try {
        final chatId = await _chatService.addNewMessage(
            event.message, event.localUser, event.chatId, false);
        final chat = await _chatService.getChat(chatId);
        emit(OnNewMessageState(message: chat.lastMessage, chat.chatId));

        emit(AiLoadingMessageState());

        if (event.chatId == null) {
          final String? responseAi = await requestReponseAi(
            "Gere um título curto de até 20 caracteres com a seguinte frase: ${event.message}",
          );

          emit(TitleMessageState(title: responseAi ?? "Conversa com IA"));
        }

        String messageContext =
            await _chatService.createMessagesContext(chatId, event.message);

        String? promptResponse = await requestReponseAi(messageContext);

        promptResponse ??= "Não foi possível obter a resposta.";

        Message aiMessage = Message(
          from: MessageFrom.googleGemini.toString(),
          message: promptResponse,
          sentAt: DateTime.now().toString(),
        );

        await _chatService.addNewMessage(
            promptResponse, false, chat.chatId, false);

        emit(OnNewMessageState(message: aiMessage, chat.chatId));
      } catch (e) {
        if (event.chatId == null) {
          return emit(ErrorMessageState(errorMessage: e.toString()));
        }

        Message errorMessage = Message(
          from: "error-message",
          message: e.toString(),
          sentAt: DateTime.now().toString(),
        );
        await _chatService.addNewMessage(
            e.toString(), false, event.chatId, true);
        emit(OnNewMessageState(message: errorMessage, event.chatId!));
      }
    }
  }
}
