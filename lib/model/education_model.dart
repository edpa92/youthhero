class Education {
  final int educationId;
  final int seekerId;
  final String certificateDegreeLevel;
  final String majorDegree;
  final String schoolName;

  const Education(
      {required this.educationId,
      required this.seekerId,
      required this.certificateDegreeLevel,
      required this.majorDegree,
      required this.schoolName});

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      educationId: json['educationId'],
      seekerId: json['seekerId'],
      certificateDegreeLevel: json['certificateDegreeLevel'],
      majorDegree: json['majorDegree'],
      schoolName: json['schoolName'],
    );
  }
}
