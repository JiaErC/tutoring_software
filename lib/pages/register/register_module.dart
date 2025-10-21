/*代码复用来自Kazumi*/
import 'package:tutoring_software/pages/register/register_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

//注册路由的具体设置,导航到注册界面
class RegisterModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const RegisterPage());
  }
}
