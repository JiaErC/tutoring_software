import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/pages/menu/menu.dart';
import 'package:tutoring_software/modules/status/status_controller.dart';
import 'package:tutoring_software/modules/signature/signature_controller.dart';
import 'package:tutoring_software/modules/avatar/avatar_controller.dart';

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
  //获取签名控制器
  final SignatureController _signatureController =
      Modular.get<SignatureController>();
  //获取头像控制器
  final AvatarController _avatarController = Modular.get<AvatarController>();
  //初始化状态
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    // 在首帧渲染后恢复登录状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreLoginStatus();
      // 调用异步方法，使用then处理完成后的回调
      _initSignature().then((_) {
        setState(() {
          _isInitializing = false;
        });
      });
    });
  }

  // 修改_initSignature方法为异步方法
  Future<void> _initSignature() async {
    try {
      // 使用Future.wait等待多个异步操作同时完成
      await Future.wait([
        _signatureController.init(_statusController.uID),
        _avatarController.init(_statusController.uID),
      ]);

      debugPrint('index_page.dart 所有初始化完成');

      // 在这里执行需要等待初始化完成后才执行的其他方法
      _doSomethingAfterInitialization();
    } catch (e) {
      debugPrint('index_page.dart 初始化过程中发生错误: $e');
    }
  }

  // 添加一个在初始化完成后执行的方法
  void _doSomethingAfterInitialization() {
    // 这里放置需要在所有初始化完成后执行的代码
    debugPrint('执行初始化后的操作');
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
    if (_isInitializing) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return const ScaffoldMenu();
  }
}
