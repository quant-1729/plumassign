import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Utils/Constants.dart';
import '../Widgets/primary_button_2.dart';
import '../services/shared_pref.dart';
import 'quiz_description_screen.dart';

class QuizCategorySelection extends StatefulWidget {
  const QuizCategorySelection({Key? key}) : super(key: key);

  @override
  State<QuizCategorySelection> createState() => _QuizCategorySelectionState();
}

class _QuizCategorySelectionState extends State<QuizCategorySelection> {
  String? selectedCategory;

  final List<Map<String, dynamic>> categories = [
    {
      'id': 'science',
      'name': 'Science',
      'icon': Icons.science,
      'description': 'Explore the wonders of science and nature',
      'color': Colors.blue,
    },
    {
      'id': 'technology',
      'name': 'Technology',
      'icon': Icons.computer,
      'description': 'Discover the latest in tech and innovation',
      'color': Colors.green,
    },
    {
      'id': 'history',
      'name': 'History',
      'icon': Icons.history_edu,
      'description': 'Journey through time and historical events',
      'color': Colors.orange,
    },
    {
      'id': 'mathematics',
      'name': 'Mathematics',
      'icon': Icons.calculate,
      'description': 'Challenge your mathematical skills',
      'color': Colors.purple,
    },
    {
      'id': 'literature',
      'name': 'Literature',
      'icon': Icons.menu_book,
      'description': 'Dive into the world of books and writing',
      'color': Colors.red,
    },
    {
      'id': 'geography',
      'name': 'Geography',
      'icon': Icons.public,
      'description': 'Explore the world and its places',
      'color': Colors.teal,
    },
  ];

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
          'Choose Quiz Category',
          style: TextStyle(
            color: AppColors.infinite_black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a category for your quiz',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.text_grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.w,
                  mainAxisSpacing: 15.h,
                  childAspectRatio: 0.85,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category['id'];
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category['id'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? (category['color'] as Color).withOpacity(0.1)
                            : AppColors.infinite_white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isSelected 
                              ? category['color'] as Color
                              : AppColors.infinite_grey,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                color: category['color'] as Color,
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Icon(
                                category['icon'] as IconData,
                                color: Colors.white,
                                size: 30.sp,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              category['name'] as String,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.infinite_black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              category['description'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.text_grey,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            PrimaryButton(
              text: 'Continue',
              backgroundColor: selectedCategory != null 
                  ? AppColors.infinite_orange 
                  : AppColors.infinite_steel_blue,
              textColor: Colors.white,
              onPressed: () async {
                if( selectedCategory != null){
                  await SharedPrefService.saveQuizCategory(selectedCategory!);
                  // Navigate to quiz description screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizDescriptionScreen(),
                    ),
                  );

                }
                  // Save selected category

              }
            ),
          ],
        ),
      ),
    );
  }
}
