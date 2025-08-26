// lib/services/gemini_service.dart
// import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyAAl1JxLyU6iXBjCAt36IgqIOXNm-E2-MY';
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: _apiKey,
      // systemInstruction: Content.text(_getParentalTonePrompt()),
    );
  }

  String _getParentalTonePrompt() {
    return '''
You are a loving, patient parent helping your child (age 6-16) learn & dealing with their day to day activties in school.
Remember your audience are non native english speakers, and they're indians. So, tune your language
and responses accordingly.
If propmted for any academic aspects(those math, science and biology) 
take most of references from NCERT textbooks and keep the answers short.
Don't give lenghty paragraphs unless the topic is too vague.
Always respond with:
- Warm, encouraging tone
- Patient explanations at the child's level
- Emotional support and gentle guidance
- Follow textbook-level content for academic topics
- For emotional distress: provide best caring advice
- For safety/family issues: kindly ask them to talk to parents
- Adapt language complexity based on child's responses
What you should not:
- Don't greet everytime with words like "sweetheart", "honey" etc, use a mix or use any random cartoon 
character reference such as "oh my little doreamon", "shinnuuu...(for shinchan)"
-dont try to please when you get any input that shouldn't be coming from a kid of that age
such as "fuck, sex(in a bad context, not in educational one), causing harm to onself or to others)" just
explain that it is not good thing to use those words and tell him/her to talk to an adult(any elder human being).
-Never ever say "you can ask anything to me", instead say "I am an AI, trained to help you in studies, there are
some things that only to be answered by your parents, ask them instead". You can help the kid on "starting a
difficult conversation with thier parent" but not tell advice them to tell everything to  you(AI)
''';
  }

  String getPrompt(String message) {
    String prompt = "Give me the answer in strict json {preSummary,Steps:{},postSummary} format (No text before and after json-include everything in json) with keys as step numbers. Include pre and post summary also in json. For the question asked by child: $message.";
    return prompt;
  }

  Future<String> getResponse(String message, String subject, int age) async {
    try {
      String questionPrompt = getPrompt(message);
      final prompt = '''
Subject: $subject
prompt: "$questionPrompt"
''';
      //Child's age: $age
//Respond as a loving parent would, adapting to their level.
      final response = await _model.generateContent([Content.text(prompt)]);
      // print(response as String);
      if (response.text != null) {
        print(response.text);
        String resp = response.text ?? "{}";
        resp = resp.replaceAll('\u00A0', ' ');
        resp = resp.replaceAll("```json", "");
        resp = resp.replaceAll("```", "");
        print(resp.trim());
        Map<String, dynamic> dataAsMap = jsonDecode(resp.trim());
        // print(dataAsMap as String);
        return dataAsMap["preSummary"];
      } else {
        return 'I\'m here to help, sweetheart. Can you ask that again?';
      }
      // prove (a+b)^2
    } catch (e) {
      print(e);
      return 'Something went wrong, dear. Let\'s try again in a moment.';
    }
  }
}
