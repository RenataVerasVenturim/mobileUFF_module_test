import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/student_model.dart';

class ClassroomProvider {
  final String accessToken;

  ClassroomProvider(this.accessToken);

  Future<Map<String, dynamic>> enrollStudent({
    required String courseId,
    required StudentModel student,
    required String enrollmentCode,
  }) async {
    final url =
        "https://classroom.googleapis.com/v1/courses/$courseId/students?enrollmentCode=$enrollmentCode";

    print("Tentando inscrever studentId=${student.userId} no courseId=$courseId");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(student.toJson()),
    );

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Erro ao inscrever aluno: ${response.statusCode} ${response.body}");
    }
  }
}
