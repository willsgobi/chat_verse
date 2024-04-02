import 'package:chat_verse/src/core/providers/i_ai_provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GoogleGeminiProvider implements IAiProvider {
  @override
  Future<String?> sendPrompt(String message) async {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: const String.fromEnvironment("GOOGLE_GEMINI_KEY"),
      // safetySettings: [
      //   SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high)
      // ],
    );

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    return response.text;
  }
}
