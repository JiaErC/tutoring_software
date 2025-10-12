/*代码复用来自Kazumi*/
import 'package:tutoring_software/pages/home/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

//主页路由的设置,导航到主页页面
class HomeModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const HomePage());
  }
}
