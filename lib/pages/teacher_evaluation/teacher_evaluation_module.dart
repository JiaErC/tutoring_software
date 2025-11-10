import 'package:flutter_modular/flutter_modular.dart';
import 'package:tutoring_software/pages/teacher_evaluation/teacher_evaluation_page.dart';

// 教师评价模块
class TeacherEvaluationModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const TeacherEvaluationPage());
  }
}