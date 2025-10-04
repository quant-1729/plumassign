import 'package:flutter/material.dart';

import '../Models/ai_quiz_models.dart';
import '../Widgets/assesments/question_container.dart';
import '../Widgets/primary_button_2.dart';


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
    // Calculate score
    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers.contains(questions[i].correctAnswer)) {
        correctAnswers++;
      }
    }
    
    setState(() {
      score = correctAnswers;
      isQuizCompleted = true;
    });
  }

  void _restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedAnswers = [];
      isQuizCompleted = false;
      score = 0;
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              percentage >= 70 ? Icons.celebration : 
              percentage >= 50 ? Icons.thumb_up : Icons.school,
              size: 80,
              color: percentage >= 70 ? Colors.green : 
                     percentage >= 50 ? Colors.orange : Colors.red,
            ),
            SizedBox(height: 24),
            Text(
              'Quiz Complete!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'You scored $score out of ${questions.length}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: percentage >= 70 ? Colors.green : 
                       percentage >= 50 ? Colors.orange : Colors.red,
              ),
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _restartQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Retake Quiz'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Go Back'),
                  ),
                ),
              ],
            ),
          ],
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
              child: LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
            
            // Question
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    QuestionContainer(
                      onSelectedAnswersChanged: (selectedIndices) {
                        setState(() {
                          selectedAnswers = selectedIndices;
                        });
                      },
                      Question: currentQuestion.problemStatement,
                      options: currentQuestion.options,
                    ),
                  ],
                ),
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
                      child: PrimaryButton(
                        text: currentQuestionIndex == questions.length - 1 ? "Finish Quiz" : "Next Question",
                        backgroundColor: selectedAnswers.isNotEmpty ? Colors.orange : Colors.grey,
                        textColor: Colors.white,
                        onPressed: (){
                          if(selectedAnswers.isNotEmpty){
                          _nextQuestion();
                          }
                        },
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


