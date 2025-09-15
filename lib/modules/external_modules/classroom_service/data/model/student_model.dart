class StudentModel {
  final String userId;

  StudentModel({required this.userId});

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(userId: json['userId']);
  }
}
