import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:plumassign/Utils/constants.dart';

class QuestionContainer extends StatefulWidget {
  final Function(List<int>) onSelectedAnswersChanged;
  final String Question;
  final List<String>? options;

   QuestionContainer({
    Key? key,
    required this.onSelectedAnswersChanged,
    required this.Question,
    this.options,
  }) : super(key: key);

  @override
  State<QuestionContainer> createState() => _QuestionContainerState();
}

class _QuestionContainerState extends State<QuestionContainer> {
  Set<int> selectedIndices = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      color: AppColors.infite_blue_bg2,
      child: Column(
        children: [
          // Question using TeXView
          Expanded(
            flex: 1,
            child: TeXView(
              style: TeXViewStyle(padding: TeXViewPadding.only(left: 10, right: 10)),
              child: TeXViewColumn(children: [
                TeXViewDocument(widget.Question),
              ]),
            ),
          ),
          
          // Options using regular Flutter widgets for interactivity
          if (widget.options != null) ...[
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: widget.options!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = selectedIndices.contains(index);
                    
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedIndices.contains(index)) {
                              selectedIndices.remove(index);
                            } else {
                              selectedIndices.clear();
                              selectedIndices.add(index);
                            }
                            widget.onSelectedAnswersChanged(selectedIndices.toList());
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppColors.infinite_steel_blue 
                                : AppColors.infinite_white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: isSelected 
                                  ? AppColors.infinite_steel_blue 
                                  : Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20.w,
                                height: 20.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected 
                                      ? AppColors.infinite_white 
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected 
                                        ? AppColors.infinite_white 
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        size: 12.sp,
                                        color: AppColors.infinite_steel_blue,
                                      )
                                    : null,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: isSelected 
                                        ? AppColors.infinite_white 
                                        : AppColors.infinite_black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}