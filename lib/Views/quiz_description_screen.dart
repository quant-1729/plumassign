import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Utils/Constants.dart';
import '../Widgets/primary_button_2.dart';
import '../services/shared_pref.dart';
import 'quiz_loading_screen.dart';

class QuizDescriptionScreen extends StatefulWidget {
  const QuizDescriptionScreen({Key? key}) : super(key: key);

  @override
  State<QuizDescriptionScreen> createState() => _QuizDescriptionScreenState();
}

class _QuizDescriptionScreenState extends State<QuizDescriptionScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String? selectedDifficulty;
  String? selectedCategory;

  final List<String> difficultyLevels = [
    'Easy',
    'Medium',
    'Hard',
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedCategory();
  }

  Future<void> _loadSelectedCategory() async {
    final category = await SharedPrefService.getQuizCategory();
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.infinite_white,
      appBar: AppBar(
        backgroundColor: AppColors.infinite_white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.infinite_black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Quiz Details',
          style: TextStyle(
            color: AppColors.infinite_black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Display
            if (selectedCategory != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.infite_blue_bg2,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.infinite_blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.category, color: AppColors.infinite_blue),
                    SizedBox(width: 12.w),
                    Text(
                      'Selected Category: ${_getCategoryDisplayName(selectedCategory!)}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.infinite_blue,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],

            // Quiz Title
            Text(
              'Quiz Title',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.infinite_black,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter a title for your quiz',
                hintStyle: TextStyle(color: AppColors.text_grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.infinite_grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.infinite_orange, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
            SizedBox(height: 24.h),

            // Difficulty Level
            Text(
              'Difficulty Level',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.infinite_black,
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 12.w,
              children: difficultyLevels.map((difficulty) {
                final isSelected = selectedDifficulty == difficulty;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDifficulty = difficulty;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.infinite_orange 
                          : AppColors.infinite_white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected 
                            ? AppColors.infinite_orange 
                            : AppColors.infinite_grey,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      difficulty,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isSelected 
                            ? Colors.white 
                            : AppColors.infinite_black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 24.h),

            // Quiz Description
            Text(
              'Quiz Description',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.infinite_black,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe what this quiz will cover and any special instructions...',
                hintStyle: TextStyle(color: AppColors.text_grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.infinite_grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.infinite_orange, width: 2),
                ),
                contentPadding: EdgeInsets.all(16.w),
              ),
            ),
            SizedBox(height: 32.h),

            // Start Quiz Button
            PrimaryButton(
              text: 'Start Quiz',
              backgroundColor: _canStartQuiz() 
                  ? AppColors.infinite_orange 
                  : AppColors.infinite_steel_blue,
              textColor: Colors.white,
              onPressed: () async {
                // Save quiz details
                await SharedPrefService.saveQuizTitle(_titleController.text);
                await SharedPrefService.saveQuizDescription(_descriptionController.text);
                await SharedPrefService.saveQuizDifficulty(selectedDifficulty!);

                 // Navigate to quiz loading screen
                 Navigator.pushReplacement(
                   context,
                   MaterialPageRoute(
                     builder: (context) => QuizLoadingScreen(),
                   ),
                 );
              }
            ),
          ],
        ),
      ),
    );
  }

  bool _canStartQuiz() {
    return _titleController.text.trim().isNotEmpty &&
           _descriptionController.text.trim().isNotEmpty &&
           selectedDifficulty != null;
  }

  String _getCategoryDisplayName(String categoryId) {
    switch (categoryId) {
      case 'science':
        return 'Science';
      case 'technology':
        return 'Technology';
      case 'history':
        return 'History';
      case 'mathematics':
        return 'Mathematics';
      case 'literature':
        return 'Literature';
      case 'geography':
        return 'Geography';
      default:
        return categoryId.toUpperCase();
    }
  }
}
