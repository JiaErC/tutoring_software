/*代码复用来自Kazumi*/
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/pages/chat/chat_page.dart';
import 'package:tutoring_software/pages/chat/search/search_module.dart';

//聊天路由的具体设置,导航到聊天页面
class ChatModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const ChatPage());
    //添加搜索子路由
    r.module("/search", module: SearchModule());
  }
}
