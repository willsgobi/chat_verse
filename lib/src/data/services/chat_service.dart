import 'package:chat_verse/src/data/repositories/chat_repository.dart';
import 'package:chat_verse/src/domain/enums/message_from.dart';
import 'package:chat_verse/src/domain/models/chat.dart';
import 'package:chat_verse/src/domain/models/message.dart';

class ChatService {
  final ChatRepository _chatRepository;
  ChatService(this._chatRepository);

  Future<List<ChatModel>?> getChats() {
    try {
      return _chatRepository.getChats();
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatModel> getChat(String chatId) {
    try {
      return _chatRepository.getChat(chatId);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> addNewMessage(
      String message, bool localUser, String? chatId, bool isError) async {
    try {
      final messageSent = await _chatRepository.addMessage(
          Message(
            from: isError
                ? MessageFrom.errorMessage.toString()
                : localUser
                    ? MessageFrom.localUser.toString()
                    : MessageFrom.googleGemini.toString(),
            message: message,
            sentAt: DateTime.now().toString(),
          ),
          chatId);

      return messageSent.chatId;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createMessagesContext(
      String chatId, String lastMessage) async {
    try {
      final currentChat = await _chatRepository.getChat(chatId);

      String messageContext = '''
Esse é o contexto dessa conversa, você precisa entendê-lo por completo. As mensagens estão enumeradas de 1 até o final, sendo 1 a primeira mensagem, ou seja, você terá um histórico dessa conversa, desde a primeira até a última mensagem enviada pelo usuário (a última mensagem). 
Você precisa ler cada mensagem, verificar com atenção o que o usuário mandou e o que você já respondeu para continuar a conversa.\n 
Dicas:
• Não se repita, verifique atentamente as mensagens enviadas por você para não se repetir
• Entenda o contexto com atenção e responda o usuário de forma clara e não tão formal
• Converse como você fosse um amigo(a) do usuário
• Faça com que ele se sinta cativado com suas respostas
• Tenha como base sempre a última mensagem enviada pelo usuário, porém, tenha em mante que o contexto é primordial para que o usuário se sinta entendido. 
• De continuidade na conversa, se você não entendeu, pergunte, se você entendeu, responda de forma clara
          ''';

      final messages = currentChat.messages.reversed.take(30).toList();

      for (var i = 0; i < messages.length; i++) {
        final message = messages[i];
        if (message.message == lastMessage) continue;
        messageContext += "\n";

        if (message.from == MessageFrom.localUser.toString()) {
          messageContext +=
              "${i + 1} • mensagem enviada pelo usuário: ${message.message}.";
        }

        if (message.from == MessageFrom.googleGemini.toString()) {
          messageContext +=
              "${i + 1} • mensagem enviada por você: ${message.message}.";
        }
      }

      messageContext += "\n";

      messageContext +=
          "\nEssa é a ultima mensagem enviada pelo usuário que você deverá responde-la de acordo com o contexto dela e com o contexto das outras mensagens:\n";
      messageContext += lastMessage;
      messageContext +=
          "\nSe você não entendeu, ou o assunto da última mensagem difere do contexto, você pode enviar uma pergunta para o usuário para você conseguir entender e responder da melhor forma. Você também pode mudar o assunto caso o usuário deseje, sinta-se livre para entender o que o usuário quer. Atente-se a última mensagem enviada por você também, isso ajuda no prosseguimento da conversa.";

      return messageContext;
    } catch (e) {
      rethrow;
    }
  }

  Future updateChat(ChatModel chat) async {
    await _chatRepository.updatedChat(chat);
  }

  Future deleteChat(String chatId) async {
    await _chatRepository.deleteChat(chatId);
  }
}
