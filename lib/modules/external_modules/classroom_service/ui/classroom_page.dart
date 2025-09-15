import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/classroom_controller.dart';

import 'package:url_launcher/url_launcher.dart';// testar botão que redireciona para link direto (convite) - sem api


class ClassroomPage extends StatelessWidget {
  const ClassroomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClassroomController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Inscrição Classroom")),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.enrollStudentInCourse(
                    courseId: "YOUR_COURSE_ID_HERE", // substitua pelo ID real do curso
                    enrollmentCode: "YOUR_ENROLLMENT_CODE_HERE", // substitua pelo código de matrícula real
                  );
                },
                child: const Text("Inscrever-se (com API Classroom)"),
              ),
              const SizedBox(height: 20),
              Divider(),
              const Text('Botões temporários para testes:'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final tokenInfo = await controller.loginAndCheckToken();
                  if (tokenInfo != null) {
                    print("User ID: ${tokenInfo['user_id']}");
                    print("Scopes: ${tokenInfo['scope']}");
                    print("Email: ${tokenInfo['email']}");
                  }
                },
                child: const Text("Testar Token"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await controller.logoutGoogleAccount();
                },
                child: const Text("Logout Google"),
              ),
              const SizedBox(height: 20),
              Text(controller.message.value),

              ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse('YOUR_COURSE_INVITE');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    print("Não foi possível abrir o link");
                  }
                },
                child: const Text("Inscrever-se sem API"),
              )
            ],
          );
        }),
      ),
    );
  }
}
