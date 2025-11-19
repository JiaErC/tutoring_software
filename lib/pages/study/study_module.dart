/*代码复用来自Kazumi*/
import 'package:tutoring_software/pages/study/study_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'package:tutoring_software/pages/study/test_list_page.dart';
// import 'package:tutoring_software/pages/study/test_taking_page.dart';
// import 'package:tutoring_software/data/generated_test_data.dart';

//学习路由的具体设置,导航到学习界面
class StudyModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const StudyPage());
    // r.child("/test_list", child: (_) => const TestListPage());
    // r.child("/test_taking", child: (_) => TestTakingPage(testPaper: Modular.args.data as GeneratedTestPaper));
  }
}
