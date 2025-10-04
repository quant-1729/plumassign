import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Utils/Constants.dart';
import '../Widgets/primary_button_2.dart';
import 'assignment_level_page_2.dart';

class Survey extends StatefulWidget {
  final bool didrequirehelp;
  final String assignmentid;

  const Survey({
    super.key,
    required this.didrequirehelp,
    required this.assignmentid,
  });

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  TextEditingController reviewController = TextEditingController();
  int starRating = 0;
  List<int> selectedOptions = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? surveyQuestion;
  List<String> surveyOptions = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the back button
        title: Container(
          child: Center(child: Text("Survey Page")),
        )
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (surveyQuestion != null)
              Text(
                surveyQuestion!,
                style: TextStyle(
                  fontSize: AppTextsizes.medium_text,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.infinite_Bold,
                ),
              ),
            if (surveyOptions.isNotEmpty)
              ...surveyOptions.map((option) {
                int optionIndex = surveyOptions.indexOf(option) + 1;
                return SurveyFormQuestion(
                  text: option,
                  optionCount: selectedOptions,
                  optionNumber: optionIndex,
                );
              }).toList(),
            if (widget.didrequirehelp)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rate help from hints',
                    style: TextStyle(
                      fontSize: AppTextsizes.medium_text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StarRating(
                    rating: starRating,
                    onRatingChanged: (rating) {
                      setState(() {
                        starRating = rating;
                      });
                    },
                  ),
                  Text(
                    'Message (Optional)',
                    style: TextStyle(
                      fontSize: AppTextsizes.medium_text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ReviewTextField(controller: reviewController),
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(15.h),
        child: Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: "Skip",
                backgroundColor: AppColors.infinite_white,
                textColor: AppColors.infinite_orange,
                onPressed: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         AssignmentLevelPage2(chapterId: chapterId),
                  //   ),
                  // );
                },
              ),
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: PrimaryButton(
                text: "Submit",
                backgroundColor: AppColors.infinite_orange,
                textColor: AppColors.infinite_white,
                onPressed: () {
                  if (selectedOptions.isEmpty || starRating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please select at least one option and provide a rating.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                    return;
                  } else {
                    // final assignmentController = AssessmentController();
                    // assignmentController.submitSurvey(
                    //   context,
                    //   SurveyDataRequestDto(
                    //     assessmentId: widget.assignmentid,
                    //     message: reviewController.text,
                    //     rating: starRating,
                    //     options: selectedOptions,
                    //   ),
                    // );
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         AssignmentLevelPage2(chapterId: chapterId),
                    //   ),
                    // );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyFormQuestion extends StatefulWidget {
  final int optionNumber;
  final String text;
  final List<int> optionCount;

  const SurveyFormQuestion({
    super.key,
    required this.text,
    required this.optionCount,
    required this.optionNumber,
  });

  @override
  State<SurveyFormQuestion> createState() => _SurveyFormQuestionState();
}

class _SurveyFormQuestionState extends State<SurveyFormQuestion> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      elevation: 0.0,
      child: SizedBox(
        child: Row(
          children: <Widget>[
            Checkbox(
              activeColor: AppColors.infinite_orange,
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                });
                _updateOptionList();
              },
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: AppTextsizes.medium_text,
                  fontFamily: AppFonts.infinite_Bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateOptionList() {
    if (isChecked) {
      widget.optionCount.add(widget.optionNumber);
    } else {
      widget.optionCount.remove(widget.optionNumber);
    }
  }
}

class StarRating extends StatefulWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const StarRating({
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              index < widget.rating
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              color: index < widget.rating
                  ? AppColors.infinite_orange
                  : AppColors.infinite_black,
            ),
            onPressed: () {
              widget.onRatingChanged(index + 1);
            },
          ),
        );
      }),
    );
  }
}

class ReviewTextField extends StatefulWidget {
  final TextEditingController controller;

  const ReviewTextField({super.key, required this.controller});

  @override
  _ReviewTextFieldState createState() => _ReviewTextFieldState();
}

class _ReviewTextFieldState extends State<ReviewTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: TextStyle(fontSize: AppTextsizes.medium_text),
      maxLines: 5,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
