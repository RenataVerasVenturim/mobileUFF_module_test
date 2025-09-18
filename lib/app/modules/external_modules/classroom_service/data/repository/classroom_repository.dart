import '../model/student_model.dart';
import '../providers/classroom_provider.dart';

class ClassroomRepository {
  ClassroomRepository();

  Future<void> enrollStudent({
    required String courseId,
    required String enrollmentCode,
    required StudentModel student,
    required String accessToken, 
  }) async {
  
    final provider = ClassroomProvider(accessToken);

    await provider.enrollStudent(
      courseId: courseId,
      enrollmentCode: enrollmentCode,
      student: student,
    );
  }
}
