import 'package:flutter_modular/flutter_modular.dart';
import 'package:tutoring_software/pages/teacher_info/teacher_info_page.dart';

// 教师基本信息模块
class TeacherInfoModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const TeacherInfoPage());
  }
}