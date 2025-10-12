/*代码复用来自Kazumi*/
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tutoring_software/pages/chat/chat_module.dart';
import 'package:tutoring_software/pages/study/study_module.dart';
import 'package:tutoring_software/pages/my/my_module.dart';
import 'package:tutoring_software/pages/home/home_module.dart';

//路由项目的具体设置
class MenuRouteItem {
  final String path;
  final Module module;

  const MenuRouteItem({
    required this.path,
    required this.module,
  });
}

//菜单路由类的具体设置
class MenuRoute {
  final List<MenuRouteItem> menuList;

  const MenuRoute(this.menuList);

  int get size => menuList.length;

  List<Module> get moduleList {
    return menuList.map((e) => e.module).toList();
  }

  List<ModuleRoute> get routes {
    return menuList.map((e) => ModuleRoute(e.path, module: e.module)).toList();
  }

  getPath(int index) {
    return menuList[index].path;
  }
}

//这个应用可以通过导航栏达到的路由和页面
final MenuRoute menu = MenuRoute([
  MenuRouteItem(
    //主页的路由
    path: "/home",
    module: HomeModule(),
  ),
  MenuRouteItem(
    //聊天的路由
    path: "/chat",
    module: ChatModule(),
  ),
  MenuRouteItem(
    //练习的路由
    path: "/study",
    module: StudyModule(),
  ),
  MenuRouteItem(
    //我的 的路由
    path: "/my",
    module: MyModule(),
  ),
]);