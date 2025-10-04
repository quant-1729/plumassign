// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:graphite/core/typings.dart';
// import 'package:provider/provider.dart';
// import 'package:region_infinity_mobile_app/controllers/updateuserprogresscontroller.dart';
// import 'package:region_infinity_mobile_app/utils/constants.dart';
// import 'package:region_infinity_mobile_app/widgets/Pimary_button.dart';
// import 'package:region_infinity_mobile_app/widgets/primary_button_2.dart';
// import 'package:uuid/uuid.dart';
//
// import '../../controllers/provider/TreeDataAssessmentProvider.dart';
// import '../../models/DTO/ResDTO/Assignment_res/ResAsssessmentDTO.dart';
//
// class TreeBottomSheet extends StatefulWidget {
//   final String currentNodeId;
//   const TreeBottomSheet({super.key, required this.currentNodeId});
//
//   @override
//   State<TreeBottomSheet> createState() => _TreeBottomSheetState();
// }
//
// class _TreeBottomSheetState extends State<TreeBottomSheet> {
//   final UpdateUserProgressController _progressController =
//       UpdateUserProgressController(); // Add controller here
//
//   @override
//   Widget build(BuildContext context) {
//     final assessmentTreeDataProvider =
//         Provider.of<TreeDataAssessmentProvider>(context);
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       decoration: BoxDecoration(
//         color: AppColors.infite_blue_bg2,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(40.0.h),
//           topRight: Radius.circular(40.0.h),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(height: 10.h),
//           Container(
//             width: 200.w,
//             height: 4.0,
//             color: AppColors.text_grey,
//           ),
//           SizedBox(height: 20.h),
//           sheetButton("Go to node", Icons.turn_right_rounded, () {
//             assessmentTreeDataProvider.setCurrentNodeId(widget.currentNodeId);
//             Navigator.pop(context);
//             Navigator.pop(context);
//           }),
//           SizedBox(height: 10.h),
//           sheetButton("Add node", Icons.add, () {
//             showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               builder: (BuildContext context) {
//                 return Container(
//                   padding: EdgeInsets.only(
//                       bottom: MediaQuery.of(context).viewInsets.bottom),
//                   child: addnodebutton(context,
//                       (String title, String content) async {
//                     var uuid = const Uuid();
//                     var newId = uuid.v4();
//
//                     // Fetch the parent ID from the provider or another source
//                     String parentId = widget
//                         .currentNodeId; // Use the current node ID as the parent for the new node
//
//                     AssessmentResDto dto =
//                         assessmentTreeDataProvider.currentAssessment;
//
//                     // Create a TreeData object with the new node details
//                     TreeData treeData = TreeData(
//                       parentId: parentId, // Use the fetched parent node ID
//                       id: newId,
//                       assessment_id: dto.id, // Replace with appropriate ID
//                       content: content,
//                       title: title,
//                     );
//
//                     // Call updateUserProgress() to send the data
//                     await _progressController.updateUserProgress(context,treeData);
//
//                     // Add node to the provider
//                     dto.treeData.add(treeData);
//                     assessmentTreeDataProvider.setCurrentAssessment(dto);
//
//                     Navigator.pop(context);
//                   }),
//                 );
//               },
//             );
//           }),
//           SizedBox(height: 40.h),
//         ],
//       ),
//     );
//   }
// }
//
// Widget sheetButton(String title, IconData icon, Function onPressed) {
//   return Container(
//     height: 40.h,
//     decoration: BoxDecoration(
//       color: AppColors.infinite_white, // Background color
//       borderRadius: BorderRadius.circular(10), // Border radius
//     ),
//     padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h), // Padding
//     child: ListTile(
//       leading: Icon(icon),
//       title: Text(
//         title,
//         style: TextStyle(fontSize: AppTextsizes.medium_text),
//       ),
//       onTap: () {
//         onPressed();
//       },
//     ),
//   );
// }
//
// Widget addnodebutton(BuildContext context, Function(String, String) onPressed) {
//   final TextEditingController titleController =
//       TextEditingController(text: "Default Heading");
//   final TextEditingController descriptionController =
//       TextEditingController(text: "Default Description");
//
//   return SingleChildScrollView(
//     keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
//     child: Container(
//       height: 240.h,
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       decoration: BoxDecoration(
//         color: AppColors.infite_blue_bg2,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(40.0.h),
//           topRight: Radius.circular(40.0.h),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.arrow_back_ios),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               SizedBox(
//                 width: 10.w,
//               ),
//               Text(
//                 'Add your step in the message box',
//                 style: TextStyle(
//                   fontSize: AppTextsizes.medium_text,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           Container(
//             width: double.infinity,
//             height: 104.h,
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Column(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.zero,
//                     padding: EdgeInsets.zero,
//                     child: TextField(
//                       controller: titleController,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                       ),
//                       style: TextStyle(fontSize: AppTextsizes.medium_text),
//                       keyboardType: TextInputType.multiline,
//                       maxLines: null,
//                       expands: false,
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Container(
//                     margin: EdgeInsets.zero,
//                     padding: EdgeInsets.zero,
//                     height: 100.h,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: TextField(
//                         controller: descriptionController,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.zero,
//                         ),
//                         style: TextStyle(fontSize: AppTextsizes.small_text),
//                         keyboardType: TextInputType.multiline,
//                         maxLines: null,
//                         expands: false,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 24.h),
//           Container(
//             width: 324.w,
//             height: 50.h,
//             child: CustomButton(
//               text: "Add",
//               onPressed: () {
//                 String title = titleController.text;
//                 String description = descriptionController.text;
//                 onPressed(title, description);
//               },
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
