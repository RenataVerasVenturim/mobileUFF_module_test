import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/model/student_model.dart';
import '../data/repository/classroom_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassroomController extends GetxController {
  final ClassroomRepository repository;

  ClassroomController(this.repository);

  var isLoading = false.obs;
  var message = "".obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/classroom.rosters',
      'https://www.googleapis.com/auth/classroom.profile.emails',
      'https://www.googleapis.com/auth/classroom.profile.photos',
    ],
  );

  Future<String?> loginAndGetToken() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;
      final auth = await account.authentication;
      return auth.accessToken;
    } catch (e) {
      print("Erro no login: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> loginAndCheckToken() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;

      final auth = await account.authentication;
      final accessToken = auth.accessToken;
      if (accessToken == null) return null;

      final response = await http.get(
        Uri.parse('https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=$accessToken'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Token info: $data");
        return data;
      } else {
        print("Token inválido ou expirado: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Erro no login/token: $e");
      return null;
    }
  }

  Future<void> enrollStudentInCourse({
  required String courseId,
  required String enrollmentCode,
}) async {
  try {
    isLoading.value = true;

    final accessToken = await loginAndGetToken();
    if (accessToken == null) {
      message.value = "Login cancelado ou falhou";
      return;
    }

    final student = StudentModel(userId: "me");

    await repository.enrollStudent(
      courseId: courseId,
      enrollmentCode: enrollmentCode,
      student: student,
      accessToken: accessToken,
    );

    message.value = "Aluno inscrito com sucesso!";
  } catch (e) {
    if (e.toString().contains("Conflict") || e.toString().contains("already enrolled")) {
      message.value = "Você já está inscrito. Abrindo a turma...";

      final url = Uri.parse('https://classroom.google.com/c/$courseId');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } else {
      message.value = "Erro: $e";
    }
  } finally {
    isLoading.value = false;
  }
}

  Future<void> logoutGoogleAccount() async {
    try {
      await _googleSignIn.signOut();
      print("Logout realizado com sucesso");
      message.value = "Logout realizado. Faça login novamente!";
    } catch (e) {
      print("Erro ao deslogar: $e");
      message.value = "Erro ao deslogar: $e";
    }
  }
}
