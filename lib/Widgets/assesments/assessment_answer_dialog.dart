import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants.dart';

class AssessmentAnswerDialog extends StatelessWidget {
  final String? description;
  final bool iscorrect;

  AssessmentAnswerDialog({super.key, this.description, required this.iscorrect});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: AppColors.infinite_white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: AppColors.infinite_white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the Row's children
              crossAxisAlignment: CrossAxisAlignment.center, // Center the icon and text vertically
              children: [
                iscorrect ? _buildCorrectIcon() : wronganswer(),
                SizedBox(width: 8.w),
                Text(
                  iscorrect ? "Your answer is correct" : "This is the wrong option",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorrectIcon() {
    return CircleAvatar(
      backgroundColor: Colors.green,
      radius: 16.sp, // Adjust radius based on screen size
      child: Icon(Icons.check, color: Colors.white, size: 16.sp), // Adjust icon size
    );
  }

  Widget wronganswer() {
    return CircleAvatar(
      backgroundColor: Colors.red,
      radius: 16.sp, // Adjust radius based on screen size
      child: Icon(Icons.close, color: Colors.white, size: 16.sp), // Adjust icon size
    );
  }
}
