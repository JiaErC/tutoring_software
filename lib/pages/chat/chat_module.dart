/*代码复用来自Kazumi*/
import 'package:tutoring_software/pages/chat/chat_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

//聊天路由的具体设置,导航到聊天页面
class ChatModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const ChatPage());
  }
}
