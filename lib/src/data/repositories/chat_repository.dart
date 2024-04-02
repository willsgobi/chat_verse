import 'package:chat_verse/src/core/providers/i_storage_provider.dart';
import 'package:chat_verse/src/data/services/string_generator.dart';
import 'package:chat_verse/src/domain/models/chat.dart';
import 'package:chat_verse/src/domain/models/message.dart';

class ChatRepository {
  final IStorageProvider _storageProvider;

  ChatRepository(this._storageProvider);

  Future<String> createChat() async {
    try {
      var newChatId = StringGenerator.generateRandomString();
      List<String>? currentListId = await _storageProvider.getList("chatIds");

      currentListId ??= [];

      if (!currentListId.contains(newChatId)) {
        currentListId.add(newChatId);
        await _storageProvider.setList('chatIds', currentListId);
      } else {
        return createChat();
      }

      return newChatId;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatModel>?> getChats() async {
    try {
      List<ChatModel> chats = [];
      List<String>? currentListId = await _storageProvider.getList("chatIds");

      if (currentListId == null) return null;

      for (var element in currentListId) {
        String key = "chat_$element";

        var currentChat = await _storageProvider.get(key);

        if (currentChat == null || currentChat == "null") {
          throw Exception("Chat não encontrado.");
        }

        chats.add(ChatModel.fromRawJson(currentChat));
      }

      return chats;
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatModel> getChat(String chatId) async {
    try {
      String key = "chat_$chatId";
      var currentChat = await _storageProvider.get(key);

      if (currentChat == null) throw Exception("Chat não encontrado");

      return ChatModel.fromRawJson(currentChat);
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatModel> addMessage(Message message, String? chatId) async {
    try {
      chatId ??= await createChat();

      String key = "chat_$chatId";

      var currentChat = await _storageProvider.get(key);

      late ChatModel chatModel;

      if (currentChat == null || currentChat == "null") {
        List<Message> messages = [];

        messages.add(message);
        chatModel = ChatModel(
            chatId: chatId,
            title: "Nova conversa",
            imageUrl: "https://robohash.org/$chatId?set=set1",
            messages: messages,
            lastMessage: messages.last);
      } else {
        chatModel = ChatModel.fromRawJson(currentChat);

        chatModel.messages.insert(0, message);
      }

      await _storageProvider.set(key, chatModel.toRawJson());

      return chatModel;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteChat(String chatId) async {
    String key = "chat_$chatId";
    await _storageProvider.delete(key);

    List<String>? currentListId =
        await _storageProvider.getList("chatIds") ?? [];
    currentListId.removeWhere((e) => e == chatId);
    await _storageProvider.setList("chatIds", currentListId);
  }

  Future updatedChat(ChatModel chat) async {
    String key = "chat_${chat.chatId}";
    await _storageProvider.set(key, chat.toRawJson());
  }
}
