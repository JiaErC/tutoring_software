/*代码复用来自Kazumi*/
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/pages/index_page.dart';
import 'package:tutoring_software/pages/router.dart';
import 'package:tutoring_software/pages/login/login_index_page.dart';
import 'package:tutoring_software/pages/my/settings/settings_module.dart';
import 'package:tutoring_software/pages/register/register_module.dart';
import 'package:tutoring_software/pages/subjects/subjects_module.dart';
import 'package:tutoring_software/pages/register/register_controller.dart';
import 'package:tutoring_software/pages/login/login_controller.dart';
import 'package:tutoring_software/pages/my/my_controller.dart';
import 'package:tutoring_software/pages/chat/search/search_controller.dart';
import 'package:tutoring_software/pages/subjects/subjects_controller.dart'; 
import 'package:tutoring_software/modules/signature/signature_controller.dart';
import 'package:tutoring_software/modules/avatar/avatar_controller.dart';
import 'package:tutoring_software/modules/comment/comment_controller.dart';
import 'package:tutoring_software/pages/teacher_info/teacher_info_module.dart'; 
import 'package:tutoring_software/pages/test_scoring/test_scoring_module.dart';
import 'package:tutoring_software/pages/teacher_evaluation/teacher_evaluation_module.dart';
import 'package:tutoring_software/pages/selecter/selecter_module.dart';
import 'package:tutoring_software/pages/selecter/selecter_controller.dart';
import 'package:tutoring_software/modules/relationship/teacher_controller.dart';

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
    i.addSingleton(RegisterController.new);
    i.addSingleton(LoginController.new);
    i.addSingleton(MyController.new);
    i.addSingleton(SearchController.new);
    i.addSingleton(SubjectsController.new);
    i.addSingleton(SignatureController.new);
    i.addSingleton(AvatarController.new);
    i.addSingleton(CommentController.new);
    i.addSingleton(SelecterController.new);
    i.addSingleton(TeacherController.new);
    i.get<MyController>().init();
    i.get<SubjectsController>().init();
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
    r.module("/subjects", module: SubjectsModule()); //科目路由
    r.module("/settings", module: SettingsModule()); //设置路由
    r.module("/register", module: RegisterModule()); //注册路由
    // r.module("/search", module: SearchModule());
    r.module("/reacher_info",module:TeacherInfoModule());
    r.module("/test_scoring",module:TestScoringModule());
    r.module("/teacher_evaluation",module:TeacherEvaluationModule());
    r.module("/selecter",module:SelecterModule());
  }
}
