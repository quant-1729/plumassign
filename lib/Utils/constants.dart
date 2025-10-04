import 'dart:ui';

class AppFonts {
  static const String infinite_Bold = 'Inter Bold';
  static const String infinite_Semibold = 'Inter Bold';
  static const String infinite_Medium = 'Inter Medium';
  static const String infinite_Regular = 'Inter Regular';
  static const String infinite_Light = 'Inter Light';
}

class AppColors {
  static const Color infinite_blue = Color(0xFF004E89);
  static const Color infite_blue_bg2 = Color(0xFFF1F6FF);
  static const Color infinite_orange = Color(0xFF7309e3);
  static const Color infinite_grey = Color(0xFFF1F6FF);
  static const Color infinite_black = Color(0xFF303030);
  static const Color infinite_white = Color(0xFFFFFFFF);
  static const Color infinite_steel_blue = Color.fromRGBO(150, 154, 168, 1);
  static const Color text_grey = Color(0xFF878787);
  static const Color text_light = Color.fromRGBO(150, 154, 168, 1);
}

class AppTextsizes {
  static double large_text = 24;
  static double medium_text = 16;
  static double small_text = 12;
}

class AppConfig {
  static const String geminiApiKey = "AIzaSyB47jRVUgjiTjs_UuKgW8qeQ_L_RxOv6dE";
  static const String geminiApiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";
  static const int quizQuestionCount = 7;
  
  static const String openaiApiKey = "YOUR_OPENAI_API_KEY_HERE"; // Replace with your actual API key
  static const String openaiApiUrl = "https://api.openai.com/v1/chat/completions";
}