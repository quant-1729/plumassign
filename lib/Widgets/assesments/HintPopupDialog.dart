// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_tex/flutter_tex.dart';
// import 'package:provider/provider.dart';
// import 'package:region_infinity_mobile_app/models/DTO/ResDTO/Assignment_res/ResAsssessmentDTO.dart';
// import 'package:region_infinity_mobile_app/utils/constants.dart';
//
// import '../../controllers/provider/TreeDataAssessmentProvider.dart';
// import '../../views/assessments/concept_tree.dart';
//
// class HintPopupDialog extends StatefulWidget {
//   const HintPopupDialog({super.key});
//
//   @override
//   State<HintPopupDialog> createState() => _HintPopupDialogState();
// }
//
// class _HintPopupDialogState extends State<HintPopupDialog> {
//   @override
//   Widget build(BuildContext context) {
//     final assessmentTreeDataProvider =
//     Provider.of<TreeDataAssessmentProvider>(context);
//     TreeData currentTreeData = assessmentTreeDataProvider
//         .currentAssessment.treeData
//         .firstWhere((element) =>
//     element.id == assessmentTreeDataProvider.currentNodeId);
//
//     return Dialog(
//       surfaceTintColor: AppColors.infinite_white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.8,
//         padding: EdgeInsets.all(16.w), // Add consistent padding
//         child: Stack(
//           alignment: AlignmentDirectional.center,
//           clipBehavior: Clip.none,
//           children: [
//             Positioned(
//                 right: -10,
//                 child: Container(
//                   padding: EdgeInsets.all(3.sp),
//                   decoration: BoxDecoration(
//                       color: AppColors.infinite_white,
//                       borderRadius: BorderRadius.circular(20)),
//                   child: GestureDetector(
//                     onTap: () {
//                       TreeData? nextNode = assessmentTreeDataProvider
//                           .currentAssessment.treeData
//                           .firstWhere((element) =>
//                       element.parentId ==
//                           assessmentTreeDataProvider.currentNodeId);
//                       assessmentTreeDataProvider.setCurrentNodeId(nextNode.id);
//                     },
//                     child: Container(
//                         padding: EdgeInsets.all(2.sp),
//                         decoration: BoxDecoration(
//                             color: AppColors.infinite_orange,
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Icon(
//                           Icons.arrow_forward,
//                           size: 17.sp,
//                           color: Colors.white,
//                         )),
//                   ),
//                 )),
//             Positioned(
//                 left: -10,
//                 child: Container(
//                   padding: EdgeInsets.all(3.sp),
//                   decoration: BoxDecoration(
//                       color: AppColors.infinite_white,
//                       borderRadius: BorderRadius.circular(20)),
//                   child: GestureDetector(
//                     onTap: () {
//                       TreeData? previousNode = assessmentTreeDataProvider
//                           .currentAssessment.treeData
//                           .firstWhere((element) =>
//                       element.id == currentTreeData.parentId);
//                       assessmentTreeDataProvider
//                           .setCurrentNodeId(previousNode.id);
//                     },
//                     child: Container(
//                         padding: EdgeInsets.all(2.sp),
//                         decoration: BoxDecoration(
//                             color: AppColors.infinite_orange,
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Icon(
//                           Icons.arrow_back,
//                           size: 17.sp,
//                           color: Colors.white,
//                         )),
//                   ),
//                 )),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           currentTreeData.title,
//                           softWrap: true,
//                           overflow: TextOverflow.ellipsis,  // Handle long text
//                           maxLines: 2,  // Limit lines for title
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18.sp,
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.auto_graph_rounded),
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => ConceptTreePage()));
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20.0),
//                   // Ensure TeXView handles dynamic content properly
//                   TeXView(
//                     renderingEngine: TeXViewRenderingEngine.mathjax(),
//                     style: TeXViewStyle(
//                       padding: TeXViewPadding.all(10.w.toInt()),
//                       margin: TeXViewMargin.all(5.w.toInt()),
//                       backgroundColor: Colors.transparent,
//                     ),
//                     child: TeXViewDocument(currentTreeData.content),
//                   ),
//                   SizedBox(height: 20.0),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
