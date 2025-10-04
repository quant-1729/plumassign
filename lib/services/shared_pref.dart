import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('refresh_token');
  }

  static Future<void> savespid(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('spid', token);
  }

  static Future<String?> getspid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('spid');
  }

  static Future<void> removespid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('spid');
  }

  static Future<void> savecid(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cid', token);
  }

  static Future<String?> getcid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('cid');
  }

  static Future<void> removecid() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cid');
  }

  // Save that user has completed onboarding (has visited before)
  static Future<void> savefirsttimevisit() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("has_completed_onboarding", true);
  }
  
  // Check if user has completed onboarding before
  // Returns true if user has visited before, false/null if new user
  static Future<bool?> getfirsttimevisit() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("has_completed_onboarding");
  }
  
  // Clear onboarding status (for testing or logout)
  static Future<void> clearOnboardingStatus() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("has_completed_onboarding");
  }

  // Quiz Category Management
  static Future<void> saveQuizCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quiz_category', category);
  }

  static Future<String?> getQuizCategory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('quiz_category');
  }

  static Future<void> removeQuizCategory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quiz_category');
  }

  // Quiz Title Management
  static Future<void> saveQuizTitle(String title) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quiz_title', title);
  }

  static Future<String?> getQuizTitle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('quiz_title');
  }

  static Future<void> removeQuizTitle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quiz_title');
  }

  // Quiz Description Management
  static Future<void> saveQuizDescription(String description) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quiz_description', description);
  }

  static Future<String?> getQuizDescription() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('quiz_description');
  }

  static Future<void> removeQuizDescription() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quiz_description');
  }

  // Quiz Difficulty Management
  static Future<void> saveQuizDifficulty(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quiz_difficulty', difficulty);
  }

  static Future<String?> getQuizDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('quiz_difficulty');
  }

  static Future<void> removeQuizDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quiz_difficulty');
  }

  // Clear all quiz data
  static Future<void> clearQuizData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quiz_category');
    await prefs.remove('quiz_title');
    await prefs.remove('quiz_description');
    await prefs.remove('quiz_difficulty');
  }
}
