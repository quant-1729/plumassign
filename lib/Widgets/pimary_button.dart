import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utils/Constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(text,style: TextStyle(fontSize: AppTextsizes.large_text),),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(10.h),

          foregroundColor: AppColors.infinite_white, 
          backgroundColor: AppColors.infinite_orange,
        )
    );
  }
}
