class AssessmentResponseDTO {
  final String? result;
  final String? solution;
  final bool? surveyRequired;

  AssessmentResponseDTO({
    required this.result,
    required this.solution,
    required this.surveyRequired,
  });

  factory AssessmentResponseDTO.fromJson(Map<String, dynamic> json) {
    return AssessmentResponseDTO(
      result: json['result'],
      solution: json['solution'],
      surveyRequired: json['survey_required']?? false,
    );
  }
}


