class AssessmentRequestDTO {
  final List<String> data;

  AssessmentRequestDTO({required this.data});

  Map<String, dynamic> toJson() {
    return {
      'data': data,
    };
  }
}
