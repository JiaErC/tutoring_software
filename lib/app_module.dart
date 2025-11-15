/*代码复用来自Kazumi*/
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/pages/index_module.dart';
import 'package:tutoring_software/modules/status/status_controller.dart';
import 'package:tutoring_software/modules/user_data/user_data_controller.dart';
import 'package:tutoring_software/modules/account_manager/account_controller.dart';

//定义了根路由
class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(StatusController.new);
    i.addSingleton(UserDataController.new);
    i.addSingleton(AccountController.new);
    //状态控制模块初始化
    i.get<StatusController>().init();
  }

  @override
  void routes(r) {
    r.module("/", module: IndexModule());
  }
}
