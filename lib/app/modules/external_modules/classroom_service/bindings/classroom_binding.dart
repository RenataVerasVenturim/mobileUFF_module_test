import 'package:get/get.dart';
import '../controller/classroom_controller.dart';
import '../data/repository/classroom_repository.dart';

class ClassroomBinding extends Bindings {
  @override
  void dependencies() {
    // Repository sem provider fixo
    Get.lazyPut(() => ClassroomRepository());

    // Controller que usa o repository
    Get.lazyPut(() => ClassroomController(Get.find()));
  }
}
