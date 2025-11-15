import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:getwidget/getwidget.dart';

import 'package:tutoring_software/modules/status/status_controller.dart';
import 'package:tutoring_software/modules/user_data/user_data_controller.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  //引入登录状态控制器
  final StatusController _statusController = Modular.get<StatusController>();
  //引入用户账号控制器
  final UserDataController _userDataController =
      Modular.get<UserDataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //这个是显示当前的用途
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Modular.to.pushNamed("/tab/my/"),
        ),
        title: const Text("账号资料"),
        elevation: 15, // 添加阴影效果，值越大阴影越深
        backgroundColor: Colors.white, // 设置背景色为白色
        foregroundColor: Colors.black, // 设置文字和图标颜色为黑色
        // 移除AppBar下方的边框线，使阴影更加自然
        scrolledUnderElevation: 4.0,
        shadowColor: Colors.black,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Container(
          margin: EdgeInsets.only(top: 80),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bulidAvatar(),
              _buildDivider(),
              //修改用户名、电话号码、邮箱
              _buildEditTile(
                Icons.person,
                _statusController.uName,
                "用户名",
                () {},
              ),
              _buildDivider(),
              //修改电话号码
              _buildEditTile(
                Icons.phone,
                _statusController.uPhone,
                "电话号码",
                () {},
              ),
              _buildDivider(),
              //修改邮箱
              _buildEditTile(
                Icons.email,
                _statusController.uEmail,
                "邮箱",
                () {},
              ),
              _buildDivider(),
              //修改生日
              _buildEditTile(
                Icons.calendar_today,
                _statusController.uBirthday,
                "生日",
                () {},
              ),
              _buildDivider(),
              //性别信息
              _buildEditTile(
                Icons.wc,
                _statusController.uGender,
                "性别",
                () {},
              ),
              _buildDivider(),
              //个人身份
              _buildEditTile(
                Icons.people,
                _statusController.uRole,
                "个人身份",
                () {},
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  //常用的Divider
  Widget _buildDivider() {
    return Divider(
      height: 5,
      color: Colors.grey[850]!.withOpacity(0.7),
      indent: 20,
      endIndent: 20,
    );
  }

  //这里是头像显示区域
  Widget _bulidAvatar() {
    return SizedBox(
      width: 800,
      height: 100,
      child: ListTile(
        leading: GFAvatar(
          backgroundImage: AssetImage("lib/data/images/1.png"),
          radius: 80,
        ),
        trailing: Text(
          "头像",
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          // 显示底部弹出菜单
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SafeArea(
                child: SizedBox(
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text('拍照'),
                        onTap: () {
                          // 实现拍照功能
                          Navigator.of(context).pop();
                          // 这里将来可以添加相机拍照的代码
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('从相册中选择'),
                        onTap: () {
                          // 实现从相册选择功能
                          Navigator.of(context).pop();
                          // 这里将来可以添加从相册选择的代码
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            // 设置菜单样式
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            // 启用可拖动关闭
            enableDrag: true,
          );
        },
      ),
    );
  }

  Widget _buildEditTile(
    IconData icon,
    String uT,
    String text,
    VoidCallback? f,
  ) {
    return SizedBox(
      height: 70,
      width: 800,
      child: InkWell(
        onTap: f,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                Icon(icon),
                Text(uT, style: TextStyle(fontSize: 16, color: Colors.black54)),
              ],
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //生日选择
}
