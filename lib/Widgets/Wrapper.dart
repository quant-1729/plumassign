import 'package:flutter/material.dart';
import 'package:plumassign/Views/assessment_page.dart';
import 'package:plumassign/Views/onborading/onbordignmain.dart';
import 'package:plumassign/Views/quiz_category_selection.dart';
import 'package:plumassign/services/shared_pref.dart';

class Wrapper extends StatefulWidget {
   Wrapper({super.key});
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isNewUser = false;
  bool isLoading = true;
  Future<void> navigate() async {
    try {
      bool? hasVisitedBefore = await SharedPrefService.getfirsttimevisit();
      setState(() {
        // If null or false, user is new (hasn't visited before)
        isNewUser = hasVisitedBefore != true;
        isLoading = false;
      });

      if (isNewUser) {
        // New user - show onboarding
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => OnBordingMain())
        );
      } else {
        // Returning user - go to quiz category selection
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => QuizCategorySelection())
        );
      }
    } catch (e) {
      // Handle error - default to new user
      setState(() {
        isNewUser = true;
        isLoading = false;
      });
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => OnBordingMain())
      );
    }
  }

  @override
  void initState() {
    super.initState();
    navigate(); // Call navigate when widget initializes
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
