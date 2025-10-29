/*代码复用来自Kazumi*/
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/pages/index_module.dart';

//定义了根路由
class AppModule extends Module {
  @override
  void binds(i) {
  }

  @override
  void routes(r) {
    r.module("/", module: IndexModule());
  }
}
