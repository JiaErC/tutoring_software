import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/pages/menu/menu.dart';
import 'package:tutoring_software/modules/status/status_controller.dart';

//再者各路由中的加载导航栏
class IndexPage extends StatefulWidget {
  //const IndexPage({super.key});
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with WidgetsBindingObserver {
  //获取状态控制器
  final StatusController _statusController = Modular.get<StatusController>();
  
  @override
  void initState() {
    super.initState();
    // 在首帧渲染后恢复登录状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreLoginStatus();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 当依赖变化时（如热重载后）也尝试恢复状态
    _restoreLoginStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 当应用从后台回到前台时，也恢复状态
    if (state == AppLifecycleState.resumed) {
      _restoreLoginStatus();
    }
  }

  // 恢复登录状态的方法
  void _restoreLoginStatus() {
    try {
      // 从Hive重新加载登录状态
      _statusController.init();
      debugPrint(
        'index_page.dart_登录状态已恢复: ${_statusController.isLogin}, 用户ID: ${_statusController.uID}',
      );
    } catch (e) {
      debugPrint('index_page.dart_恢复登录状态失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const ScaffoldMenu();
  }
}
