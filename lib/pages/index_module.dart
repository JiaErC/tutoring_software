/*代码复用来自Kazumi*/
// import 'package:kazumi/pages/index_page.dart';
// import 'package:kazumi/pages/router.dart';
// import 'package:kazumi/pages/init_page.dart';
// import 'package:kazumi/pages/popular/popular_controller.dart';
// import 'package:kazumi/plugins/plugins_controller.dart';
// import 'package:kazumi/pages/video/video_controller.dart';
// import 'package:kazumi/pages/timeline/timeline_controller.dart';
// import 'package:kazumi/pages/collect/collect_controller.dart';
// import 'package:kazumi/pages/my/my_controller.dart';
// import 'package:kazumi/pages/history/history_controller.dart';
// import 'package:kazumi/pages/video/video_module.dart';
// import 'package:kazumi/pages/info/info_module.dart';
// import 'package:kazumi/pages/settings/settings_module.dart';
// import 'package:kazumi/shaders/shaders_controller.dart';
// import 'package:kazumi/pages/search/search_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tutoring_software/pages/index_page.dart';
import 'package:tutoring_software/pages/router.dart';
import 'package:tutoring_software/pages/login/login_index_page.dart';
import 'package:tutoring_software/pages/my/settings/settings_module.dart';
import 'package:tutoring_software/pages/register/register_module.dart';

//目的是定义整个软件的路由
class IndexModule extends Module {
  @override
  List<Module> get imports => [...menu.moduleList, ...login.moduleList];

  @override
  void binds(i) {
    //这段是绑定一些依赖模块,暂时用不到
    // i.addSingleton(PopularController.new);
    // i.addSingleton(PluginsController.new);
    // i.addSingleton(VideoPageController.new);
    // i.addSingleton(TimelineController.new);
    // i.addSingleton(CollectController.new);
    // i.addSingleton(HistoryController.new);
    // i.addSingleton(MyController.new);
    // i.addSingleton(ShadersController.new);
  }

  @override
  void routes(r) {
    r.redirect('/', to: "/tab");
    //检测初始化情况,也暂时用不到
    // r.child("/"),
    //     child: (_) => const InitPage(),
    //     children: [
    //       ChildRoute(
    //         "/error",
    //         child: (_) => Scaffold(
    //           appBar: AppBar(title: const Text("Kazumi")),
    //           body: const Center(child: Text("初始化失败")),
    //         ),
    //       ),
    //     ],
    //     transition: TransitionType.noTransition);
    r.child(
      "/tab",
      child: (_) {
        return const IndexPage();
      },
      children: menu.routes,
      transition: TransitionType.fadeIn,
      duration: Duration(milliseconds: 70),
    );
    //登录的路由
    r.child(
      "/login",
      child: (_) {
        return const LoginIndexPage();
      },
      children: login.routes,
      transition: TransitionType.fadeIn,
      duration: Duration(milliseconds: 70),
    );
    //这些路由模块暂时用不到,等后面用
    // r.module("/video", module: VideoModule());
    // /// The route need [ BangumiItem ] as argument.
    // r.module("/info", module: InfoModule());
    r.module("/settings", module: SettingsModule());
    //注册路由
    r.module("/register",module: RegisterModule());
    // r.module("/search", module: SearchModule());
  }
}
