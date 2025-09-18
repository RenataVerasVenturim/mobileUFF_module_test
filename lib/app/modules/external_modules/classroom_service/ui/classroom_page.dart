import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/classroom_controller.dart';
import '../../../../../routes/app_routes.dart';

class ClassroomPage extends StatelessWidget {
  const ClassroomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClassroomController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Turmas com inscrições abertas"),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Divider(),
                const Text("SummerClass 2026 - Desenvolvimento Mobile em Flutter"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    controller.enrollStudentInCourse(
                      courseId: "YOUR_CLASSROOM_COURSE_ID_HERE", // Substitua pelo ID real da turma
                      enrollmentCode: "YOUR_ENROLLMENT_CODE_HERE", // Substitua pelo código real de inscrição
                    );
                  },
                  child: const Text("Participar da turma"),
                ),
                const SizedBox(height: 20),
                const Divider(),
                /**
                const Text('Botões temporários para testes:'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await controller.listCourses();
                  },
                  child: const Text("Listar cursos"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await controller.loginAndCheckToken();
                  },
                  child: const Text("Testar Token"),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.tokenInfo.isEmpty) {
                    return const Text("Nenhum token carregado");
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User ID: ${controller.tokenInfo['user_id'] ?? ''}"),
                      Text("Scopes: ${controller.tokenInfo['scope'] ?? ''}"),
                      Text("Email: ${controller.tokenInfo['email'] ?? ''}"),
                    ],
                  );
                }),
                */
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await controller.logoutGoogleAccount();
                  },
                  child: const Text("Logout Google"),
                ),
                const SizedBox(height: 20),
                Obx(() => Text(controller.message.value)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    const url =
                        'YOUR_CLASSROOM_ENROLLMENT_URL_HERE'; // Substitua pela URL real
                    Get.toNamed(
                      AppRoutes.classroomWebView,
                      arguments: {'url': url},
                    );
                  },
                  child: const Text("Inscrever-se sem API"),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
