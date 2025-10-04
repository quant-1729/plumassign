import 'package:flutter/material.dart';
import 'dart:async';

import '../../Models/ai_quiz_models.dart';
import '../../Widgets/assesments/question_container.dart';
import '../../Widgets/animated_button.dart';
import '../../Widgets/confetti_celebration.dart';
import '../../Widgets/custom_progress_indicator.dart';
import 'Survey.dart';


class AssessmentPage extends StatefulWidget {
  final String assignmentid;
  final AIQuizResponse? aiGeneratedQuiz;

  AssessmentPage({Key? key, required this.assignmentid, this.aiGeneratedQuiz}) : super(key: key);

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  List<int> selectedAnswers = [];
  List<AIQuestion> questions = [];
  int currentQuestionIndex = 0;
  bool isQuizCompleted = false;
  int score = 0;
  Timer? _surveyTimer;
  bool _surveyShown = false;
  List<List<int>> allAnswers = []; // Track answers for all questions

  @override
  void initState() {
    super.initState();
    if (widget.aiGeneratedQuiz != null && widget.aiGeneratedQuiz!.success) {
      questions = widget.aiGeneratedQuiz!.questions;
    } else {
      // Fallback to hardcoded questions if no AI quiz provided
      _loadFallbackQuestions();
    }
  }

  @override
  void dispose() {
    _surveyTimer?.cancel();
    super.dispose();
  }

  void _loadFallbackQuestions() {
    questions = [
      AIQuestion(
        id: '1',
        problemStatement: 'What is the capital of France?',
        options: ['London', 'Berlin', 'Paris', 'Madrid'],
        correctAnswer: 2,
      ),
      AIQuestion(
        id: '2',
        problemStatement: 'Which planet is known as the Red Planet?',
        options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
        correctAnswer: 1,
      ),
    ];
  }

  void _nextQuestion() {
    // Store the current question's answer
    allAnswers.add(List.from(selectedAnswers));
    
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswers = [];
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    // Store the last question's answer
    allAnswers.add(List.from(selectedAnswers));
    
    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      if (i < allAnswers.length && allAnswers[i].contains(questions[i].correctAnswer)) {
        correctAnswers++;
      }
    }
    
    // Debug information
    print('Quiz completed!');
    print('Total questions: ${questions.length}');
    print('All answers: $allAnswers');
    print('Correct answers: $correctAnswers');
    
    setState(() {
      score = correctAnswers;
      isQuizCompleted = true;
    });

    // Start timer to show survey after 4 seconds
    _startSurveyTimer();
  }

  void _startSurveyTimer() {
    _surveyTimer = Timer(Duration(seconds: 4), () {
      if (mounted && !_surveyShown) {
        _showSurvey();
      }
    });
  }

  void _showSurvey() {
    if (_surveyShown) return;
    
    setState(() {
      _surveyShown = true;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Survey(
          didrequirehelp: true, // Set to true to show rating and message fields
          assignmentid: widget.assignmentid,
          onSurveyCompleted: () {
            // Optional: Add any additional logic when survey is completed
            print('Survey completed for assignment: ${widget.assignmentid}');
          },
        ),
      ),
    ).then((_) {
      // Survey completed, reset the flag
      setState(() {
        _surveyShown = false;
      });
    });
  }

  void _restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedAnswers = [];
      isQuizCompleted = false;
      score = 0;
      allAnswers = []; // Reset all answers
    });
  }



  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('No questions available'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (isQuizCompleted) {
      return _buildQuizResultScreen();
    }

    return _buildQuestionScreen();
  }

  Widget _buildQuizResultScreen() {
    final percentage = (score / questions.length * 100).round();
    final category = widget.aiGeneratedQuiz?.questions.isNotEmpty == true 
        ? 'your selected topic' 
        : 'the quiz';
    
    return ConfettiCelebration(
      isActive: percentage >= 80,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Quiz Results'),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 40),
              
              // Motivational Message
              MotivationalMessage(
                score: score,
                totalQuestions: questions.length,
                category: category,
              ),
              
              SizedBox(height: 32),
              
              // Score Display
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Score',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$score / ${questions.length}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: percentage >= 70 ? Colors.green : 
                               percentage >= 50 ? Colors.orange : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 32),
              if (!_surveyShown)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.feedback_outlined, color: Colors.blue, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'We\'d love to hear your feedback! A survey will appear shortly.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              SizedBox(height: 32),
              
              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedButton(
                      text: 'Retake Quiz',
                      onPressed: _restartQuiz,
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                      icon: Icon(Icons.refresh, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedButton(
                      text: 'Try Different Category',
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context); // Go back to category selection
                      },
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      icon: Icon(Icons.category, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedButton(
                      text: 'Go Back',
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: Colors.grey[600]!,
                      textColor: Colors.white,
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    final currentQuestion = questions[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentQuestionIndex + 1} of ${questions.length}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress indicator
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: CustomProgressIndicator(
                progress: (currentQuestionIndex + 1) / questions.length,
                label: 'Progress',
                activeColor: Colors.orange,
                backgroundColor: Colors.grey[300],
                showPercentage: true,
                animated: true,
              ),
            ),
            
            // Question
            Expanded(
              child: QuestionContainer(
                onSelectedAnswersChanged: (selectedIndices) {
                  setState(() {
                    selectedAnswers = selectedIndices;
                  });
                },
                Question: currentQuestion.problemStatement,
                options: currentQuestion.options,
              ),
            ),
            
            // Action buttons
            Column(
              children: [
                if (selectedAnswers.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Answer selected: ${currentQuestion.options[selectedAnswers.first]}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                Row(
                  children: [
                    Expanded(
                      child: AnimatedButton(
                        text: currentQuestionIndex == questions.length - 1 ? "Finish Quiz" : "Next Question",
                        backgroundColor: selectedAnswers.isNotEmpty ? Colors.orange : Colors.grey,
                        textColor: Colors.white,
                        onPressed: selectedAnswers.isNotEmpty ? _nextQuestion : null,
                        icon: Icon(
                          currentQuestionIndex == questions.length - 1 
                              ? Icons.flag 
                              : Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


