import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plumassign/Utils/constants.dart';
import '../Utils/Constants.dart';
import '../Models/ai_quiz_models.dart';

class AIQuizService {
  static final AIQuizService _instance = AIQuizService._internal();
  factory AIQuizService() => _instance;
  AIQuizService._internal();

  // Try Gemini first (free), fallback to OpenAI if needed
  Future<AIQuizResponse> generateQuiz(AIQuizRequest request) async {
    try {
      // First try Gemini API (free)
      if (AppConfig.geminiApiKey != "YOUR_GEMINI_API_KEY_HERE") {
        return await _generateWithGemini(request);
      }
      
      // Fallback to OpenAI if Gemini key not configured
      if (AppConfig.openaiApiKey != "YOUR_OPENAI_API_KEY_HERE") {
        return await _generateWithOpenAI(request);
      }
      
      // If no API keys configured, return mock data for testing
      return _generateMockQuiz(request);
      
    } catch (e) {
      print('Error generating quiz: $e');
      return AIQuizResponse.error('Failed to generate quiz: ${e.toString()}');
    }
  }

  Future<AIQuizResponse> _generateWithGemini(AIQuizRequest request) async {
    try {
      final prompt = _buildPrompt(request);
      
      final requestBody = {
        "contents": [
          {
            "parts": [
              {
                "text": prompt
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.7,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 2048,
        }
      };

      final response = await http.post(
        Uri.parse('${AppConfig.geminiApiUrl}?key=${AppConfig.geminiApiKey}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['candidates'][0]['content']['parts'][0]['text'];
        return _parseAIResponse(content);
      } else {
        throw Exception('Gemini API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Gemini API error: $e');
      // Fallback to OpenAI if Gemini fails
      return await _generateWithOpenAI(request);
    }
  }

  Future<AIQuizResponse> _generateWithOpenAI(AIQuizRequest request) async {
    try {
      final prompt = _buildPrompt(request);
      
      final requestBody = {
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content": "You are a quiz generator. Generate educational quiz questions in the exact JSON format specified."
          },
          {
            "role": "user",
            "content": prompt
          }
        ],
        "max_tokens": 2048,
        "temperature": 0.7,
      };

      final response = await http.post(
        Uri.parse(AppConfig.openaiApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConfig.openaiApiKey}',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'];
        return _parseAIResponse(content);
      } else {
        throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('OpenAI API error: $e');
      // Final fallback to mock data
      return _generateMockQuiz(request);
    }
  }

  AIQuizResponse _generateMockQuiz(AIQuizRequest request) {
    // Generate mock quiz data for testing when APIs are not available
    final mockQuestions = <AIQuestion>[];
    
    for (int i = 1; i <= request.questionCount; i++) {
      mockQuestions.add(AIQuestion(
        id: 'mock_$i',
        problemStatement: _getMockQuestion(request.category, i),
        options: _getMockOptions(request.category, i),
        correctAnswer: i % 4, // Cycle through options 0-3
      ));
    }
    
    return AIQuizResponse(
      questions: mockQuestions,
      success: true,
    );
  }

  String _buildPrompt(AIQuizRequest request) {
    return '''
Generate a quiz with ${request.questionCount} multiple choice questions about ${request.category}.

Quiz Title: ${request.title}
Description: ${request.description}
Difficulty Level: ${request.difficulty}

Requirements:
1. Each question should have exactly 4 options (A, B, C, D)
2. Questions should be appropriate for ${request.difficulty.toLowerCase()} difficulty
3. Include a mix of factual and conceptual questions
4. Make questions engaging and educational

Return the response in this EXACT JSON format:
{
  "questions": [
    {
      "id": "1",
      "problemStatement": "What is the capital of France?",
      "options": ["London", "Berlin", "Paris", "Madrid"],
      "correctAnswer": 2
    }
  ]
}

Important: 
- correctAnswer should be the INDEX of the correct option (0, 1, 2, or 3)
- problemStatement should be clear and concise
- options should be plausible but only one should be correct
- Focus on ${request.category} topics
''';
  }

  AIQuizResponse _parseAIResponse(String content) {
    try {
      // Clean the response - remove any markdown formatting
      String cleanContent = content.trim();
      if (cleanContent.startsWith('```json')) {
        cleanContent = cleanContent.substring(7);
      }
      if (cleanContent.endsWith('```')) {
        cleanContent = cleanContent.substring(0, cleanContent.length - 3);
      }
      
      final jsonData = json.decode(cleanContent);
      return AIQuizResponse.fromJson(jsonData);
    } catch (e) {
      print('Error parsing AI response: $e');
      print('Raw content: $content');
      
      // Try to extract JSON from the response if it's embedded in text
      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
      if (jsonMatch != null) {
        try {
          final jsonData = json.decode(jsonMatch.group(0)!);
          return AIQuizResponse.fromJson(jsonData);
        } catch (e) {
          print('Error parsing extracted JSON: $e');
        }
      }
      
      return AIQuizResponse.error('Failed to parse AI response');
    }
  }

  String _getMockQuestion(String category, int index) {
    final mockQuestions = {
      'science': [
        'What is the chemical symbol for gold?',
        'Which planet is known as the Red Planet?',
        'What is the speed of light in vacuum?',
        'What is the process by which plants make food?',
        'Which gas makes up most of Earth\'s atmosphere?',
        'What is the smallest unit of matter?',
        'What is the center of an atom called?',
      ],
      'technology': [
        'What does CPU stand for?',
        'Which programming language is known for web development?',
        'What is the full form of HTML?',
        'Which company developed the iPhone?',
        'What does API stand for?',
        'Which protocol is used for secure web communication?',
        'What is machine learning a subset of?',
      ],
      'history': [
        'In which year did World War II end?',
        'Who was the first President of the United States?',
        'Which ancient wonder was located in Egypt?',
        'In which century did the Renaissance begin?',
        'Who painted the Mona Lisa?',
        'Which empire was ruled by Julius Caesar?',
        'In which year did the Berlin Wall fall?',
      ],
      'mathematics': [
        'What is the value of π (pi) to two decimal places?',
        'What is the square root of 64?',
        'What is the formula for the area of a circle?',
        'What is 15% of 200?',
        'What is the derivative of x²?',
        'What is the sum of angles in a triangle?',
        'What is the next number in the sequence: 2, 4, 8, 16, ?',
      ],
      'literature': [
        'Who wrote "Romeo and Juliet"?',
        'Which novel begins with "It was the best of times"?',
        'Who wrote "1984"?',
        'What is the main character in "The Great Gatsby"?',
        'Who wrote "To Kill a Mockingbird"?',
        'Which Shakespeare play features a character named Hamlet?',
        'Who wrote "Pride and Prejudice"?',
      ],
      'geography': [
        'Which is the largest continent by area?',
        'What is the longest river in the world?',
        'Which country has the most population?',
        'What is the capital of Australia?',
        'Which ocean is the largest?',
        'What is the smallest country in the world?',
        'Which mountain is the highest in the world?',
      ],
    };
    
    final questions = mockQuestions[category.toLowerCase()] ?? mockQuestions['science']!;
    return questions[(index - 1) % questions.length];
  }

  List<String> _getMockOptions(String category, int index) {
    final mockOptions = {
      'science': [
        ['Au', 'Ag', 'Fe', 'Cu'],
        ['Mars', 'Venus', 'Jupiter', 'Saturn'],
        ['300,000 km/s', '299,792,458 m/s', '186,000 miles/s', '150,000,000 km/s'],
        ['Respiration', 'Photosynthesis', 'Digestion', 'Fermentation'],
        ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'],
        ['Molecule', 'Atom', 'Cell', 'Electron'],
        ['Proton', 'Nucleus', 'Neutron', 'Electron'],
      ],
      'technology': [
        ['Central Processing Unit', 'Computer Processing Unit', 'Central Program Unit', 'Core Processing Unit'],
        ['Python', 'JavaScript', 'Assembly', 'Cobol'],
        ['HyperText Markup Language', 'High Tech Modern Language', 'Home Tool Markup Language', 'Hyperlinks and Text Markup Language'],
        ['Samsung', 'Apple', 'Google', 'Microsoft'],
        ['Application Programming Interface', 'Advanced Programming Interface', 'Automated Programming Interface', 'Application Process Interface'],
        ['HTTP', 'HTTPS', 'FTP', 'TCP'],
        ['Artificial Intelligence', 'Data Science', 'Computer Science', 'Information Technology'],
      ],
      'history': [
        ['1944', '1945', '1946', '1947'],
        ['John Adams', 'George Washington', 'Thomas Jefferson', 'Benjamin Franklin'],
        ['Hanging Gardens', 'Great Pyramid', 'Colossus', 'Lighthouse'],
        ['14th', '15th', '16th', '17th'],
        ['Vincent van Gogh', 'Leonardo da Vinci', 'Pablo Picasso', 'Michelangelo'],
        ['Roman', 'Greek', 'Persian', 'Egyptian'],
        ['1988', '1989', '1990', '1991'],
      ],
      'mathematics': [
        ['3.14', '3.15', '3.13', '3.16'],
        ['8', '6', '7', '9'],
        ['πr²', '2πr', 'πd', 'πr'],
        ['25', '30', '35', '40'],
        ['2x', 'x', 'x²', '2'],
        ['90°', '180°', '270°', '360°'],
        ['24', '32', '28', '20'],
      ],
      'literature': [
        ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'],
        ['A Tale of Two Cities', 'Great Expectations', 'Oliver Twist', 'David Copperfield'],
        ['George Orwell', 'Aldous Huxley', 'Ray Bradbury', 'H.G. Wells'],
        ['Nick Carraway', 'Jay Gatsby', 'Daisy Buchanan', 'Tom Buchanan'],
        ['Harper Lee', 'Truman Capote', 'Mark Twain', 'John Steinbeck'],
        ['Macbeth', 'Hamlet', 'Othello', 'King Lear'],
        ['Charlotte Brontë', 'Jane Austen', 'Emily Brontë', 'Virginia Woolf'],
      ],
      'geography': [
        ['Africa', 'Asia', 'North America', 'Europe'],
        ['Amazon', 'Nile', 'Mississippi', 'Yangtze'],
        ['India', 'China', 'United States', 'Brazil'],
        ['Sydney', 'Melbourne', 'Canberra', 'Perth'],
        ['Atlantic', 'Pacific', 'Indian', 'Arctic'],
        ['Monaco', 'Vatican City', 'San Marino', 'Liechtenstein'],
        ['K2', 'Mount Everest', 'Kilimanjaro', 'Denali'],
      ],
    };
    
    final options = mockOptions[category.toLowerCase()] ?? mockOptions['science']!;
    return options[(index - 1) % options.length];
  }
}
