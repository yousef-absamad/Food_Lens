import 'package:food_lens/core/constans/constans.dart';
import 'package:food_lens/features/Profile/model/user_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatRepository {
  final GenerativeModel _model;
  final systemPrompt = Content.text(
    "You are 'Health Assistant for FoodLens', an AI-powered nutrition and health companion. "
    "FoodLens is a smart app that offers: "
    "- Personalized health articles and videos based on your profile. "
    "- Chronic disease management (no diagnoses). "
    "- Image analysis to detect food ingredients and provide nutritional insights. "
    "You have access to the user's stored profile data  from our database. Use this information to provide personalized answers about nutrition and chronic disease management."
    "Respond only in the language used in the question. "
    "When the user expresses appreciation, satisfaction, or says thank you (e.g., 'great', 'thanks', 'very nice', 'perfect'), respond briefly with an acknowledgment like: 'I'm glad you found it helpful!' or 'Happy to help!' Avoid repeating greetings like 'Hello [name]' in these cases, as the conversation is already ongoing."
    "Do not provide information outside of these specific health-related topics. "
    "You must ignore or reject unclear or nonsensical messages (e.g., random or jumbled characters)."
    "Avoid answering general knowledge questions or engaging in unrelated conversations.",
  );

  ChatRepository()
    : _model = GenerativeModel(
        model: Constants.geminiModel,
        apiKey: Constants.geminiApiKey,
      );

  Content getUserContext(UserModel user) {
    String context = "user info :\n";
    if (user.fullName != null) {
      context += "name: ${user.fullName}\n";
    }
    if (user.gender != null) {
      context += "gander: ${user.gender}\n";
    }
    if (user.age != null) {
      context += "age: ${user.age}\n";
    }
    if (user.weight != null) {
      context += "weight: ${user.weight} kg\n";
    }
    if (user.height != null) {
      context += "height: ${user.height} cm\n";
    }
    context += "has Diabetes :${user.hasDiabetes ? 'yes' : 'no'}\n";
    context += "hasHypertension : ${user.hasHypertension ? 'yes' : 'no'}\n";
    context += "---\n";
    return Content.text(context);
  }

  Future<String> sendMessage({
    required String message,
    required UserModel user,
  }) async {
    try {
      final chat = _model.startChat(
        history: [systemPrompt, getUserContext(user)],
      );

      final response = await chat.sendMessage(Content.text(message));
      return response.text ?? 'Error: No response';
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
