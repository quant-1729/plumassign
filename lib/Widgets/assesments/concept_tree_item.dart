// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:graphite/graphite.dart';
// import 'package:provider/provider.dart';
// import 'package:region_infinity_mobile_app/utils/constants.dart';
// import 'package:region_infinity_mobile_app/widgets/assesments/tree_bottom_sheet.dart';
// import '../../controllers/provider/TreeDataAssessmentProvider.dart';
// import '../../models/DTO/ResDTO/Assignment_res/ResAsssessmentDTO.dart';
//
// class ConceptTreeItem extends StatefulWidget {
//   ConceptTreeItem({super.key});
//
//   @override
//   State<ConceptTreeItem> createState() => _ConceptTreeItemState();
// }
//
// class _ConceptTreeItemState extends State<ConceptTreeItem> {
//   @override
//   void initState() {
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final assessmentTreeDataProvider = Provider.of<TreeDataAssessmentProvider>(context);
//     return SizedBox(
//       child: InteractiveViewer(
//         constrained: false,
//         child: DirectGraph(
//           maxScale: 5.0,
//           list: TreeDataToNodeInputData(context),
//           centered: true,
//           nodeBuilder: (_,nodeInput){
//             var node_details = assessmentTreeDataProvider.currentAssessment.treeData.firstWhere((element) => element.id==nodeInput.id);
//
//             return Container(
//               padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
//               decoration: BoxDecoration(
//                 color: nodeInput.id==assessmentTreeDataProvider.currentNodeId?AppColors.infinite_blue:AppColors.infite_blue_bg2,
//                 borderRadius: BorderRadius.circular(10)
//               ),
//                 child: Center(child: Text(node_details.title,textAlign: TextAlign.center,style: TextStyle(
//                   fontSize: AppTextsizes.medium_text,
//                   color: nodeInput.id==assessmentTreeDataProvider.currentNodeId?AppColors.infinite_white:AppColors.infinite_orange),)),
//             );
//           },
//           onNodeLongPressStart: (pressDetail, node, rect){
//             showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               builder: (BuildContext context) {
//                 return TreeBottomSheet(currentNodeId: node.id,); // Use your custom bottom sheet widget
//               },
//             );
//           },
//           defaultCellSize: const Size(100.0, 100.0),
//           cellPadding: const EdgeInsets.all(20),
//           orientation: MatrixOrientation.Vertical,
//         ),
//       ),
//     );
//   }
//    List<NodeInput> TreeDataToNodeInputData(BuildContext context){
//      final assessmentTreeDataProvider = Provider.of<TreeDataAssessmentProvider>(context);
//      AssessmentResDto assessmentResDto = assessmentTreeDataProvider.currentAssessment;
//     List<NodeInput> nodeInputList=[];
//     String parentId=assessmentResDto.id;
//     populateNodeData(parentId,assessmentResDto.treeData,nodeInputList);
//     nodeInputList.removeWhere((element) => element.id==parentId);
//     return nodeInputList;
//   }
//   static populateNodeData(parentId, List<TreeData>? treeData, List<NodeInput> inputNodeList){
//       List<EdgeInput> childIds=[];
//
//       treeData?.forEach((element) {
//         if(element.parentId==parentId){
//           childIds.add(EdgeInput(outcome: element.id));
//         }
//       });
//       inputNodeList.add(NodeInput(id: parentId, next: childIds));
//       childIds.forEach((element) {
//         populateNodeData(element.outcome, treeData, inputNodeList);
//       });
//   }
// }
