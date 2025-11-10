import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:getwidget/getwidget.dart';

import 'package:tutoring_software/bean/widgets/edge_box.dart';
import 'package:tutoring_software/modules/status/status_controller.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  //获取状态控制器
  final StatusController statusController = Modular.get<StatusController>();
  //是否已经登录
  bool get _isLogin => statusController.isLogin;
  //是否是老师
  bool get _isStudent => statusController.uRole.contains("1") ? true : false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: Row(
              children: [_userAvatar(context), _buildingButtonArea(context)],
            ),
          ),
        ],
      ),
    );
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
              color: _isLogin
                  ? _isStudent
                        ? Colors.green.shade100
                        : Colors.red.shade100
                  : Colors.black26,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isLogin
                    ? _isStudent
                          ? Colors.green.shade500
                          : Colors.red.shade500
                    : Colors.white,
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
                      key: ValueKey<bool>(_isStudent),
                      color: _isLogin
                          ? _isStudent
                                ? Colors.green.shade600
                                : Colors.red.shade600
                          : Colors.black87,
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
                      key: ValueKey<bool>(_isStudent),
                      style: TextStyle(
                        color: _isLogin
                            ? _isStudent
                                  ? Colors.green.shade600
                                  : Colors.red.shade600
                            : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  // 添加一个交换图标
                  Icon(
                    _isLogin ? Icons.swap_horiz : MdiIcons.login,
                    color: _isLogin
                        ? _isStudent
                              ? Colors.green.shade600
                              : Colors.red.shade600
                        : Colors.black,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // GFButton(
      //   onPressed: () => debugPrint("点击切换身份按钮"),
      //   fullWidthButton: true,
      //   type: GFButtonType.outline,
      //   shape: GFButtonShape.square,
      //   color: Colors.blue.shade50,
      //   splashColor: Colors.blue.shade100,
      //   focusColor: Colors.blue.shade400,
      //   highlightColor: Colors.blue.shade100,
      //   text: "当前身份：学生",
      //   textStyle: TextStyle(
      //     color: Colors.black,
      //     fontSize: 24,
      //     height: 1.2,
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Icon(Icons.school, size: 20),
      //       SizedBox(width: 8),
      //       Text("点击切换为老师"),
      //       SizedBox(width: 8),
      //       Icon(Icons.swap_horiz, size: 20),
      //     ],
      //   ),
      // ),
    );
  }
}
