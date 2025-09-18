import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/model/student_model.dart';
import '../data/repository/classroom_repository.dart';
//import 'package:url_launcher/url_launcher.dart';
import '../../../../../routes/app_routes.dart';

class ClassroomController extends GetxController {
  final ClassroomRepository repository;

  ClassroomController(this.repository);

  var isLoading = false.obs;
  var message = "".obs;

  /// Novo observable para guardar o token info
  var tokenInfo = <String, dynamic>{}.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/classroom.rosters',
      'https://www.googleapis.com/auth/classroom.profile.emails',
      'https://www.googleapis.com/auth/classroom.profile.photos',
      'https://www.googleapis.com/auth/classroom.courses', //Method: courses.list para pegar courseId da turma e listar cursos para status inscrito/não inscrito
      'https://www.googleapis.com/auth/classroom.courses.readonly', //Method: courses.list para pegar courseId da turma e listar cursos para status inscrito/não inscrito 
    ],
  );

  Future<String?> loginAndGetToken() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;
      final auth = await account.authentication;
      return auth.accessToken;
    } catch (e) {
      message.value = "Erro no login: $e";
      return null;
    }
  }

  Future<void> loginAndCheckToken() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        message.value = "Login cancelado";
        return;
      }

      final auth = await account.authentication;
      final accessToken = auth.accessToken;
      if (accessToken == null) {
        message.value = "Não foi possível obter o token";
        return;
      }

      final response = await http.get(
        Uri.parse('https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=$accessToken'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        tokenInfo.value = data;
        message.value = "Token válido!";
      } else {
        message.value = "Token inválido ou expirado";
      }
    } catch (e) {
      message.value = "Erro no login/token: $e";
    }
  }
  Future<void> listCourses() async {
  try {
    final accessToken = await loginAndGetToken();
    if (accessToken == null) {
      message.value = "Login cancelado ou falhou";
      return;
    }

    final response = await http.get(
      Uri.parse("https://classroom.googleapis.com/v1/courses"),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["courses"] != null) {
        final buffer = StringBuffer();
        for (var course in data["courses"]) {
          buffer.writeln(
              "ID: ${course['id']} | Nome: ${course['name']} | Seção: ${course['section'] ?? ''}");
        }
        message.value = buffer.toString();
      } else {
        message.value = "Nenhum curso encontrado.";
      }
    } else {
      message.value =
          "Erro ao listar cursos: ${response.statusCode} ${response.body}";
    }
  } catch (e) {
    message.value = "Erro: $e";
  }
}


  Future<void> enrollStudentInCourse({
    required String courseId,
    required String enrollmentCode,
  }) async {
    final url = 'YOUR_CLASSROOM_ENROLLMENT_URL_HERE'; // Substitua pela URL real
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
      
      Get.toNamed(
        AppRoutes.classroomWebView,
        arguments: {'url': url},
      );
   
    } catch (e) {
      if (e.toString().contains("ALREADY_EXISTS") || e.toString().contains("already enrolled")) {
        
        Future.delayed(Duration(milliseconds: 200), () {
        Get.toNamed(
          AppRoutes.classroomWebView,
          arguments: {'url': url},
        );

      });
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
      message.value = "Logout realizado. Faça login novamente!";
      tokenInfo.clear(); 
    } catch (e) {
      message.value = "Erro ao deslogar: $e";
    }
  }
}
