class SurveyDataRequestDto {
  final String assessmentId;
  final String message;
  final int rating;
  final List<int> options;

  SurveyDataRequestDto({
    required this.assessmentId,
    required this.message,
    required this.rating,
    required this.options,
  });

  factory SurveyDataRequestDto.fromJson(Map<String, dynamic> json) {
    return SurveyDataRequestDto(
      assessmentId: json['assessment_id'],
      message: json['message'],
      rating: json['rating'],
      options: List<int>.from(json['options']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assessment_id': assessmentId,
      'message': message,
      'rating': rating,
      'options': options,
    };
  }
}
