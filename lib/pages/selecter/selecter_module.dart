/*代码复用来自Kazumi*/
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/pages/selecter/selecter_page.dart';

//学习路由的具体设置,导航到学习界面
class SelecterModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const SelecterPage());
    // r.child("/test_list", child: (_) => const TestListPage());
    // r.child("/test_taking", child: (_) => TestTakingPage(testPaper: Modular.args.data as GeneratedTestPaper));
  }
}
