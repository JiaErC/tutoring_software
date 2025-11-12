import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'package:tutoring_software/bean/widgets/edge_box.dart';
import 'package:tutoring_software/modules/status/status_controller.dart';
import 'package:tutoring_software/pages/my/my_controller.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  //获取状态控制器
  final StatusController statusController = Modular.get<StatusController>();
  //获取MyController
  final MyController myController = Modular.get<MyController>();

  // 存储reaction的disposer
  ReactionDisposer? _loginReaction;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在首帧渲染后初始化
      _initializeController();
    });
  }

  void _initializeController() {
    try {
      // 初始化MyController，同步StatusController的状态
      myController.init();

      // 设置reaction来监听登录状态变化
      _loginReaction = reaction((_) => statusController.isLogin, (
        bool isLoggedIn,
      ) {
        // 使用setState确保UI更新
        setState(() {
          // 当登录状态变化时，重新初始化MyController
          myController.init();
          debugPrint('登录状态变化: $isLoggedIn');
        });
      });
    } catch (e) {
      debugPrint('初始化控制器失败: $e');
    }
  }

  @override
  void dispose() {
    // 安全地清理reaction，检查是否为null
    if (_loginReaction != null) {
      _loginReaction!();
    }
    super.dispose();
  }

  //获取登录状态和是否为老师
  bool get _isLogin => myController.isLogin;
  //获取当前用户角色
  bool get _isStudent => myController.isStudent;
  //获取当前用户教学的学科信息，选了什么学科，还有是否选择了学科
  Map<String, dynamic> get _subjects => myController.subjects;
  bool get _isSelectedSubjects => _subjects.isNotEmpty;
  //每个大学科的选择情况
  Map<String, bool> get _isViewSubjects => myController.isViewSubjects;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Row(
                children: [_userAvatar(context), _buildingButtonArea(context)],
              ),
            ),
            const SizedBox(height: 20),
            //这里放置学科显示组件
            _isLogin
                ? _isSelectedSubjects
                      ? _buildSubjects()
                      : SizedBox.shrink()
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  //文字边框的颜色设置
  Color _getRoleColor() {
    return _isStudent ? Colors.green.shade600 : Colors.red.shade600;
  }

  //背景的颜色设置
  Color _getBackgroundColor() {
    return _isStudent ? Colors.green.shade100 : Colors.red.shade100;
  }

  Widget _userAvatar(context) {
    return Expanded(
      flex: 2,
      child: GFCard(
        titlePosition: GFPosition.start,
        color: Colors.transparent,
        elevation: 0,
        title: GFListTile(
          avatar: InkWell(
            onTap: () => Modular.to.pushNamed("/login/password"),
            child: GFAvatar(
              backgroundImage: AssetImage("lib/data/images/1.png"),
              radius: 20,
            ),
          ),
          titleText: _isLogin ? statusController.uName : "点击头像登录",
          subTitleText: _isLogin
              ? "电话号码:${statusController.uPhone}\n邮箱:${statusController.uEmail}"
              : "这里是联系方式",
        ),
        content: Text("这里是简介"),
        //buttonBar:这里存放标签和联系方式
      ),
    );
  }

  //设置按钮区域和切换身份区域
  Widget _buildingButtonArea(context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [_settingButton(context), _identityTagArea(context)],
      ),
    );
  }

  //相关的设置按钮区域
  /*代码来源于PiliPlus*/
  Widget _settingButton(context) {
    return Expanded(
      flex: 2,
      child: EdgeBox(
        margin: EdgeInsets.only(right: 20, top: 10),
        child: Align(
          alignment: Alignment.topRight,
          child: GFButtonBar(
            children: [
              IconButton(
                iconSize: 22,
                padding: const EdgeInsets.all(8),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                tooltip: "进入或者退出无痕模式",
                onPressed: () => debugPrint("点击切换无痕模式按钮"),
                icon: Icon(Icons.stream),
              ),
              IconButton(
                iconSize: 22,
                padding: const EdgeInsets.all(8),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                tooltip: '设置账号模式',
                onPressed: () => debugPrint("点击切换账号模式按钮"),
                icon: const Icon(Icons.switch_account_outlined),
              ),
              IconButton(
                iconSize: 22,
                padding: const EdgeInsets.all(8),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                tooltip: '切换主题',
                onPressed: () => debugPrint("点击切换主题按钮"),
                icon: Icon(Icons.sunny),
              ),
              IconButton(
                iconSize: 22,
                padding: const EdgeInsets.all(8),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                tooltip: '设置',
                onPressed: () => Modular.to.pushNamed("/settings"),
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //显示学生和老师身份标签切换的区域
  Widget _identityTagArea(context) {
    return Expanded(
      flex: 1,
      child: EdgeBox(
        margin: EdgeInsets.only(right: 50, left: 20, top: 10, bottom: 15),
        child: Tooltip(
          message: "点击可切换学生/老师身份",
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: _isLogin ? _getBackgroundColor() : Colors.black26,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isLogin ? _getRoleColor() : Colors.white,
                width: 2,
              ),
            ),
            child: MaterialButton(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onPressed: () {
                // 这里添加切换身份的逻辑
                setState(() {
                  // 注意：这里只是为了演示UI变化，实际切换身份的逻辑需要根据您的业务需求实现
                  // 可能需要调用statusController中的方法来更新用户角色
                  if (_isLogin) myController.switchIdentity();
                  debugPrint(
                    _isLogin
                        ? "切换身份：${_isStudent ? '学生 -> 老师' : '老师 -> 学生'}"
                        : '请先登录',
                  );
                  // 实际应用中应该是类似这样的调用：
                  // statusController.switchUserRole();
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 使用AnimatedSwitcher实现图标切换动画
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return RotationTransition(turns: animation, child: child);
                    },
                    child: Icon(
                      _isLogin
                          ? _isStudent
                                ? Icons.school
                                : Icons.person
                          : Icons.lock,
                      key: ValueKey<String>('icon_\${_isStudent}'),
                      color: _isLogin ? _getRoleColor() : Colors.black87,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 8),
                  // 使用AnimatedSwitcher实现文本切换动画
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      _isLogin
                          ? _isStudent
                                ? '学生'
                                : '老师'
                          : '请先登录',
                      key: ValueKey<String>('text_\${_isStudent}'), // 修改为唯一的key
                      style: TextStyle(
                        color: _isLogin ? _getRoleColor() : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  // 添加一个交换图标
                  Icon(
                    _isLogin ? Icons.swap_horiz : MdiIcons.login,
                    color: _isLogin ? _getRoleColor() : Colors.black,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //接下来制作显示老师或者学生学习的各个学科
  Widget _buildSubjects() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Column(children: _buildBigSubjects()),
    );
  }

  //箭头形状显示选择的学科大类
  List<Widget> _buildBigSubjects() {
    List<Widget> list = [];
    _subjects.forEach((bigSubject, smallSubjects) {
      debugPrint("是否展开：${_isViewSubjects[bigSubject]}");
      list.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 150),
              width: 200,
              height: 40,
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  bottomLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomRight: Radius.circular(20),
                ),
                border: Border.all(color: _getRoleColor(), width: 2),
              ),
              child: TextButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bigSubject,
                      style: TextStyle(
                        color: _getRoleColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8), // 文本和图标之间的间距
                    Icon(
                      (_isViewSubjects[bigSubject] ?? true)
                          ? Icons.arrow_drop_down
                          : Icons.arrow_right,
                      color: _getRoleColor(),
                      size: 40,
                    ),
                  ],
                ),
                onPressed: () => setState(() {
                  debugPrint("是否展开：${_isViewSubjects[bigSubject]}");
                  myController.switchViewSubjects(bigSubject);
                }),
              ),
            ),
            _isViewSubjects[bigSubject] ?? true
                ? Column(children: _buildSmallSubjects(smallSubjects))
                : SizedBox.shrink(), //这里是学科栏目
          ],
        ),
      );
    });
    return list;
  }

  //小学科按钮
  List<Widget> _buildSmallSubjects(bs) {
    List<Widget> list = [];
    bs.forEach((smallSubject, value) {
      list.add(
        Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              AnimatedContainer(
                margin: EdgeInsets.only(top: 4),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    bottomLeft: Radius.zero,
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border.all(color: _getRoleColor(), width: 2),
                ),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    smallSubject,
                    key: ValueKey<String>('text_\${smallSubject}'), // 修改为唯一的key
                    style: TextStyle(
                      color: _getRoleColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              _buildLastSubjects(value),
            ], //添加了小学科
          ),
        ),
      );
    });
    return list;
  }

  //获取每个科目
  Widget _buildLastSubjects(ss) {
    List<Widget> list = [];
    ss.forEach((s) {
      list.add(
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: _getBackgroundColor(), width: 2),
          ),
          child: Text(
            s,
            style: TextStyle(
              color: _getRoleColor(),
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      );
    });
    //返回一个有边框的Container容器
    return Container(
      margin: EdgeInsets.only(left: 5),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: _getRoleColor(), width: 2),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: list),
      ),
    );
  }
}
