/*代码复用来自Kazumi*/
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/pages/my/info/info_page.dart';
import 'package:tutoring_software/pages/my/my_page.dart';

//我的路由的具体设置,导航到我的界面
class MyModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const MyPage());
    r.child("/info",child: (_) => const InfoPage());
  }
}
