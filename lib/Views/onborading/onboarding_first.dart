import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Utils/Constants.dart';
import '../../services/shared_pref.dart';
import '../Assessment/assessment_page.dart';
import '../Assessment/quiz_category_selection.dart';
import '../../Widgets/primary_button_2.dart';

class OnbordingScreen_one extends StatelessWidget {
  final PageController controller;
  final int pagenumber;
  final int totalpages;
  final String heading;
  final String description;
  final String image_route;

  const OnbordingScreen_one(
      {required this.controller,
        required this.pagenumber,
        required this.totalpages,
        required this.heading,
        required this.description,
        required this.image_route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image
          Positioned.fill(
            child: Image.asset(
              image_route,
              fit: BoxFit.cover,
            ),
          ),
          // Onboarding Content Container
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white, // Adjust opacity as needed
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Three-dot indicator
                  SmoothPageIndicator(
                    controller: controller,
                    count: totalpages, // Number of pages
                    effect: WormEffect(), // Choose an effect
                  ),
                  SizedBox(height: 16),
                  // Heading
                  Text(
                    heading,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Description
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  // Next button
                  PrimaryButton(
                    text: pagenumber == totalpages - 1 ? "Get Started" : "Next",
                    backgroundColor: AppColors.infinite_orange,
                    textColor: Colors.white,
                    onPressed: () {
                      if (pagenumber < totalpages - 1) {
                        controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      } else {
                        // Mark user as having completed onboarding
                         SharedPrefService.savefirsttimevisit();
                        // Navigate to quiz category selection
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(builder: (context) => QuizCategorySelection())
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
