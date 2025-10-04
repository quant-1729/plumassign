// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:region_infinity_mobile_app/views/assessments/assessment_page.dart';
//
// import '../../controllers/Assessmentcontroller.dart';
// import '../../controllers/provider/TreeDataAssessmentProvider.dart';
// import '../../models/DTO/ResDTO/Assignment_res/ResAsssessmentDTO.dart';
//
// class AssignmentLevelPage2 extends StatefulWidget {
//   final String chapterId;
//   const AssignmentLevelPage2({super.key, required this.chapterId});
//
//   @override
//   State<AssignmentLevelPage2> createState() => _AssignmentLevelPage2State();
// }
//
// class _AssignmentLevelPage2State extends State<AssignmentLevelPage2> {
//   late AssessmentController _assessmentController;
//   String? currentTreeNodeId;
//   late List<AssessmentResDto> assessmentList;
//   late List<TreeData> treeData;
//   int currentUnit = 0; // Initialize currentUnit to avoid LateInitializationError
//
//   @override
//   void initState() {
//     super.initState();
//     _assessmentController = AssessmentController();
//     _assessmentController.fetchAssessments(context, () {
//       assessmentList = _assessmentController.assessments;
//       setState(() {
//         currentUnit = findCurrentUnit(); // Find the current incomplete unit after assessments are loaded
//       });
//     }, widget.chapterId);
//   }
//
//   // Method to find the first incomplete assessment index
//   int findCurrentUnit() {
//     for (int i = 0; i < assessmentList.length; i++) {
//       if (!assessmentList[i].completed) {
//         return i + 1; // Return 1-based index of the current unit
//       }
//     }
//     return assessmentList.isEmpty ? 1 : assessmentList.length; // Ensure valid range
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Progress Tracker')),
//       body: _assessmentController.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : assessmentList.isEmpty
//           ? const Center(child: Text("No assessment in this chapter"))
//           : Column(
//         children: [
//           Flexible(
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: CustomPaint(
//                     size: Size(double.infinity, double.infinity),
//                     painter: LinePainter(currentUnit: currentUnit),
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: GridView.builder(
//                     padding: const EdgeInsets.all(16),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 5,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                     ),
//                     itemCount: assessmentList.length,
//                     itemBuilder: (context, index) {
//                       return UnitButton(
//                         unitNumber: index + 1,
//                         isCompleted: assessmentList[index].completed,
//                         isCurrent: index + 1 == currentUnit,
//                         onTap: () {
//                           print("Tapped on unit: ${index + 1}"); // Debug to ensure tap is registered
//                           loadCurrentAssessment(context, index, assessmentList);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => AssessmentPage(assignmentid: assessmentList[index].id),
//                             ),
//                           );
//                         },
//                       );
//                       ;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           )
//           ,
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 LegendItem(color: Colors.green, text: 'Path to complete'),
//                 SizedBox(height: 20,),
//                 LegendItem(color: Colors.orange, text: 'Current Position'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void loadCurrentAssessment(BuildContext context,int index, List<AssessmentResDto> assessmentList){
//     print("navigator pressed");
//     final assessmentTreeDataProvider = Provider.of<TreeDataAssessmentProvider>(context,listen: false);
//     assessmentTreeDataProvider.setCurrentAssessment(assessmentList[index]);
//     String nodeId=assessmentList[index].treeData.firstWhere((element) => element.parentId==assessmentList[index].id).id;
//     assessmentTreeDataProvider.setCurrentNodeId(nodeId);
//     _assessmentController.fetchTreeData(context, (){
//       assessmentTreeDataProvider.appendPersonalizedTreeData(_assessmentController.treeData);
//     }, assessmentList[index].id);
//   }
// }
//
// class UnitButton extends StatelessWidget {
//   final int unitNumber;
//   final bool isCompleted;
//   final bool isCurrent;
//   final VoidCallback onTap;
//
//   UnitButton({
//     required this.unitNumber,
//     required this.isCompleted,
//     required this.isCurrent,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: isCurrent ? Colors.orange : (isCompleted ? Colors.green : Colors.grey),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//           child: Text(
//             '$unitNumber',
//             style: TextStyle(color: Colors.white, fontSize: 16),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class LinePainter extends CustomPainter {
//   final int currentUnit;
//
//   LinePainter({required this.currentUnit});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint()
//       ..color = Colors.green
//       ..strokeWidth = 6
//       ..strokeCap = StrokeCap.round;  // Rounded edges for the line
//
//     var gridWidth = size.width / 5;  // 5 columns
//     var gridHeight = size.height / 5;  // 5 rows
//
//     for (int i = 0; i < currentUnit - 1; i++) {
//       var currentRow = i ~/ 5;
//       var currentCol = i % 5;
//
//       var nextRow = (i + 1) ~/ 5;
//       var nextCol = (i + 1) % 5;
//
//       // Get the center of the current box
//       var startX = currentCol * gridWidth + gridWidth / 2;
//       var startY = currentRow * gridHeight + gridHeight / 2;
//
//       // Get the center of the next box
//       var endX = nextCol * gridWidth + gridWidth / 2;
//       var endY = nextRow * gridHeight + gridHeight / 2;
//
//       // Draw a line from the center of the current box to the center of the next box
//       canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;  // Repaint when state changes
//   }
// }
//
//
// class LegendItem extends StatelessWidget {
//   final Color color;
//   final String text;
//
//   LegendItem({required this.color, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 20,
//           height: 20,
//           color: color,
//         ),
//         SizedBox(width: 8),
//         Text(text),
//       ],
//     );
//   }
// }
