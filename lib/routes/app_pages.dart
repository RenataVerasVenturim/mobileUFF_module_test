import 'package:get/get.dart';
import '../app/modules/external_modules/classroom_service/ui/classroom_page.dart';
import '../app/modules/external_modules/classroom_service/bindings/classroom_binding.dart';
import 'app_routes.dart';
import '../app/modules/external_modules/webview/ui/classroom_webview_page.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.classroomPage,
      page: () => const ClassroomPage(),
      binding: ClassroomBinding(),
    ),
    GetPage(
      name: AppRoutes.classroomWebView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return ClassroomWebViewPage(url: args['url']);
      },
      binding: ClassroomBinding(), 
    ),
  ];
}
