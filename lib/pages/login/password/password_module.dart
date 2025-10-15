import 'package:flutter_modular/flutter_modular.dart';
import 'package:tutoring_software/pages/login/password/password_page.dart';

//登录界面密码路由的具体设置,导航到密码界面
class LoginPasswordModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const PasswordPage());
  }
}
