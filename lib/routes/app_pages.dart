import 'package:get/get.dart';
import '../modules/external_modules/classroom_service/ui/classroom_page.dart';
import '../modules/external_modules/classroom_service/bindings/classroom_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.classroom,
      page: () => const ClassroomPage(),
      binding: ClassroomBinding(),
    )


  ];
}

