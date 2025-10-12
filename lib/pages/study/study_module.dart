/*代码复用来自Kazumi*/
import 'package:tutoring_software/pages/study/study_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

//学习路由的具体设置,导航到学习界面
class StudyModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const StudyPage());
  }
}
