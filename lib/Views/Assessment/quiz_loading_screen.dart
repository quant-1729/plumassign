import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Utils/Constants.dart';
import '../../Models/ai_quiz_models.dart';
import '../../services/ai_quiz_service.dart';
import '../../services/shared_pref.dart';
import 'assessment_page.dart';

class QuizLoadingScreen extends StatefulWidget {
  const QuizLoadingScreen({Key? key}) : super(key: key);

  @override
  State<QuizLoadingScreen> createState() => _QuizLoadingScreenState();
}

class _QuizLoadingScreenState extends State<QuizLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _currentMessage = 'Preparing your quiz...';
  double _progress = 0.0;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
    
    _generateQuiz();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _generateQuiz() async {
    try {
      final category = await SharedPrefService.getQuizCategory() ?? 'science';
      final title = await SharedPrefService.getQuizTitle() ?? 'Quiz';
      final description = await SharedPrefService.getQuizDescription() ?? '';
      final difficulty = await SharedPrefService.getQuizDifficulty() ?? 'Medium';

      // Create quiz request
      final quizRequest = AIQuizRequest(
        category: category,
        title: title,
        description: description,
        difficulty: difficulty,
        questionCount: AppConfig.quizQuestionCount,
      );

      // Simulate progress updates
      _updateProgress(0.1, 'Analyzing your preferences...');
      await Future.delayed(Duration(milliseconds: 500));

      _updateProgress(0.3, 'Generating questions...');
      await Future.delayed(Duration(milliseconds: 800));

      _updateProgress(0.5, 'Creating multiple choice options...');
      await Future.delayed(Duration(milliseconds: 600));

      _updateProgress(0.7, 'Finalizing your quiz...');
      await Future.delayed(Duration(milliseconds: 400));

      // Generate quiz using AI service
      final aiService = AIQuizService();
      final quizResponse = await aiService.generateQuiz(quizRequest);

      _updateProgress(0.9, 'Almost ready...');
      await Future.delayed(Duration(milliseconds: 300));

      if (quizResponse.success && quizResponse.questions.isNotEmpty) {
        _updateProgress(1.0, 'Quiz ready!');
        await Future.delayed(Duration(milliseconds: 500));

        // Navigate to assessment page with generated quiz
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AssessmentPage(
                assignmentid: "ai_quiz_${DateTime.now().millisecondsSinceEpoch}",
                aiGeneratedQuiz: quizResponse,
              ),
            ),
          );
        }
      } else {
        _showErrorDialog(quizResponse.error ?? 'Failed to generate quiz');
      }
    } catch (e) {
      print('Error in quiz generation: $e');
      _showErrorDialog('An unexpected error occurred. Please try again.');
    }
  }

  void _updateProgress(double progress, String message) {
    if (mounted) {
      setState(() {
        _progress = progress;
        _currentMessage = message;
      });
    }
  }

  void _showErrorDialog(String error) {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.infinite_black,
              ),
            ),
            content: Text(
              error,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.text_grey,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Go back to previous screen
                },
                child: Text(
                  'Go Back',
                  style: TextStyle(
                    color: AppColors.infinite_orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _generateQuiz(); // Retry
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.infinite_orange,
                  foregroundColor: Colors.white,
                ),
                child: Text('Retry'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.infinite_white,
      body: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Quiz Icon
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: AppColors.infinite_orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60.r),
              ),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.8 + (_animation.value * 0.4),
                    child: Icon(
                      Icons.quiz,
                      size: 60.sp,
                      color: AppColors.infinite_orange,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40.h),

            // Loading Message
            Text(
              _currentMessage,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.infinite_black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),

            // Progress Bar
            Container(
              width: double.infinity,
              height: 8.h,
              decoration: BoxDecoration(
                color: AppColors.infinite_grey,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.infinite_orange,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Progress Percentage
            Text(
              '${(_progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.text_grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40.h),

            // Fun Fact or Tip
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.infite_blue_bg2,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.infinite_blue.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.infinite_blue,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Tip: Take your time to read each question carefully before selecting your answer.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.infinite_blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),

            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.text_grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
