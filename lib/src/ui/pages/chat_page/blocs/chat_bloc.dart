import 'package:bloc/bloc.dart';
import 'package:chat_verse/src/data/services/chat_service.dart';
import 'package:chat_verse/src/domain/models/chat.dart';
import 'package:chat_verse/src/ui/pages/chat_page/events/chat_event.dart';
import 'package:chat_verse/src/ui/pages/chat_page/states/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService;

  ChatBloc(this._chatService) : super(InitialChatState()) {
    on(_mapEventToState);
  }

  Future _mapEventToState(ChatEvent event, Emitter<ChatState> emit) async {
    try {
      if (event is GetChatsEvent) {
        final chats = await _chatService.getChats();
        emit(LoadedChatListState(chats: chats?.reversed.toList() ?? []));
      }

      if (event is ChangeChatTitle) {
        final chat = await _chatService.getChat(event.chatId);

        final updatedChat = ChatModel(
          chatId: chat.chatId,
          title: event.title,
          imageUrl: chat.imageUrl,
          messages: chat.messages,
          lastMessage: chat.lastMessage,
        );

        await _chatService.updateChat(updatedChat);
      }

      if (event is DeleteChat) {
        try {
          await _chatService.deleteChat(event.chatId);
          emit(ChatDeletedState());
        } catch (e) {
          emit(ErrorChatState(errorMessage: e.toString()));
        }
      }
    } catch (e) {
      emit(ErrorChatState(errorMessage: e.toString()));
    }
  }
}
