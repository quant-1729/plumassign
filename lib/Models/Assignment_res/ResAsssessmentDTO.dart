class AssessmentResDto {
  String id;
  String problemStatement;
  List<String> options;
  bool listed;
  List<TreeData> treeData;
  bool completed;

  AssessmentResDto(
      {required this.id,
      required this.problemStatement,
      required this.options,
      required this.listed,
      required this.treeData,
      required this.completed});

  factory AssessmentResDto.fromJson(Map<String, dynamic> json) {
    return AssessmentResDto(
        id: json['_id'],
        problemStatement: json['problem_statement'],
        options: List<String>.from(json['options']),
        listed: json['listed'],
        completed: json['completed'] ?? false,
        treeData: (json['tree_data'] as List)
            .map((e) => TreeData.fromJson(e))
            .toList());
  }
}

class TreeData {
  String id;
  String content;
  String title;
  String? parentId;
  String? assessment_id;

  TreeData({
    required this.id,
    required this.content,
    required this.title,
    this.parentId,
   this.assessment_id
  });
 Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'title': title,
      'parent_id': parentId,
      'assessment_id': assessment_id,
    };
  }
  factory TreeData.fromJson(Map<String, dynamic> json) {
    return TreeData(
      id: json['_id'],
      assessment_id: json['assessment_id'],
      content: json['content'],
      title: json['title'],
      parentId: json['parent_id'],
    );
  }
}
