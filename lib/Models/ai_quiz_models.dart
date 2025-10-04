class AIQuizRequest {
  final String category;
  final String title;
  final String description;
  final String difficulty;
  final int questionCount;

  AIQuizRequest({
    required this.category,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.questionCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'questionCount': questionCount,
    };
  }
}

class AIQuizResponse {
  final List<AIQuestion> questions;
  final bool success;
  final String? error;

  AIQuizResponse({
    required this.questions,
    required this.success,
    this.error,
  });

  factory AIQuizResponse.fromJson(Map<String, dynamic> json) {
    return AIQuizResponse(
      questions: (json['questions'] as List)
          .map((q) => AIQuestion.fromJson(q))
          .toList(),
      success: json['success'] ?? false,
      error: json['error'],
    );
  }

  factory AIQuizResponse.error(String errorMessage) {
    return AIQuizResponse(
      questions: [],
      success: false,
      error: errorMessage,
    );
  }
}

class AIQuestion {
  final String id;
  final String problemStatement;
  final List<String> options;
  final int correctAnswer; // Index of correct answer (0-based)

  AIQuestion({
    required this.id,
    required this.problemStatement,
    required this.options,
    required this.correctAnswer,
  });

  factory AIQuestion.fromJson(Map<String, dynamic> json) {
    return AIQuestion(
      id: json['id'] ?? '',
      problemStatement: json['problemStatement'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'problemStatement': problemStatement,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }
}

class QuizGenerationStatus {
  final bool isGenerating;
  final String? message;
  final double? progress;
  final AIQuizResponse? quiz;
  final String? error;

  QuizGenerationStatus({
    this.isGenerating = false,
    this.message,
    this.progress,
    this.quiz,
    this.error,
  });

  QuizGenerationStatus copyWith({
    bool? isGenerating,
    String? message,
    double? progress,
    AIQuizResponse? quiz,
    String? error,
  }) {
    return QuizGenerationStatus(
      isGenerating: isGenerating ?? this.isGenerating,
      message: message ?? this.message,
      progress: progress ?? this.progress,
      quiz: quiz ?? this.quiz,
      error: error ?? this.error,
    );
  }
}
