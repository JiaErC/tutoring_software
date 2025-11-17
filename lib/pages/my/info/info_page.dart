import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/services.dart';

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

  // 添加TextEditingController用于处理输入
  late TextEditingController _userNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  //用于检测更新变量的一些变量
  int? _selectedGender;
  String? _selectedBirthday;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    // 初始化控制器，设置默认值
    _userNameController = TextEditingController(text: _statusController.uName);
    _phoneController = TextEditingController(text: _statusController.uPhone);
    _emailController = TextEditingController(text: _statusController.uEmail);

    // 初始化出生日期选择值    初始化性别选择值
    _selectedBirthday = _statusController.uBirthday;
    _selectedGender = int.tryParse(_statusController.uGender) ?? 0;
    // 初始化角色选择值
    _selectedRole = _statusController.uRole;
  }

  @override
  void dispose() {
    // 释放控制器资源
    _userNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bulidAvatar(),
                _buildDivider(),
                //修改用户名、电话号码、邮箱
                _buildEditTile(
                  Icons.person,
                  _userNameController.text,
                  "用户名",
                  _showEditUserNameMenu,
                ),
                _buildDivider(),
                //修改电话号码
                _buildEditTile(
                  Icons.phone,
                  _phoneController.text,
                  "电话号码",
                  _showEditPhoneMenu,
                ),
                _buildDivider(),
                //修改邮箱
                _buildEditTile(
                  Icons.email,
                  _emailController.text,
                  "邮箱",
                  _showEditEmailMenu,
                ),
                _buildDivider(),
                //修改生日
                _buildEditTile(
                  Icons.calendar_today,
                  _selectedBirthday!,
                  "生日",
                  _showEditBirthdayMenu, 
                ),
                _buildDivider(),
                //性别信息
                _buildEditTile(
                  Icons.wc,
                  getGenderText(_selectedGender!),
                  "性别",
                  _showEditGenderMenu,
                ),
                _buildDivider(),
                //个人身份
                _buildEditTile(
                  Icons.people,
                  _selectedRole!,
                  "个人身份",
                  _showEditRoleMenu,
                ),
              ],
            ),
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

  //用户名输入操作
  // 新增方法：显示修改用户名的底部菜单
  void _showEditUserNameMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许底部菜单占满更多空间
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // 适配键盘
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '修改用户名',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: '请输入新用户名',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 20, // 设置最大长度限制
                  // 自动聚焦
                  autofocus: true,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          // 取消操作
                          _userNameController.text =
                              _statusController.uName; // 恢复原值
                          Navigator.of(context).pop();
                        },
                        child: Text('取消'),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {}, //async {
                        //   // 保存新用户名
                        //   String newUserName = _userNameController.text.trim();
                        //   if (newUserName.isNotEmpty &&
                        //       newUserName != _statusController.uName) {
                        //     // 更新状态控制器中的用户名
                        //     // 由于StatusController没有直接更新单个字段的方法，我们需要创建一个新的Status实例
                        //     await _updateUserName(newUserName);
                        //   }
                        //
                        // },
                        child: Text('保存'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
  }

  // 新增：显示修改电话号码的底部菜单
  void _showEditPhoneMenu() {
    // 重置为当前值
    _phoneController.text = _statusController.uPhone;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许底部菜单占满更多空间
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // 适配键盘
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '修改电话号码',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: '请输入新电话号码',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ], // 只允许输入数字
                  maxLength: 11, // 设置最大长度限制
                  // 自动聚焦
                  autofocus: true,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          // 取消操作
                          Navigator.of(context).pop();
                        },
                        child: Text('取消'),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {}, //async {
                        //   // 保存新电话号码
                        //   String newPhone = _phoneController.text.trim();
                        //   // 简单的电话号码验证（11位数字）
                        //   if (newPhone.length == 11 && newPhone != _statusController.uPhone) {
                        //     await _updateUserInfo('phone', newPhone);
                        //   } else {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(content: Text('请输入有效的11位电话号码')),
                        //     );
                        //     return;
                        //   }
                        //   Navigator.of(context).pop();
                        // },
                        child: Text('保存'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
  }

  // 新增：显示修改邮箱的底部菜单
  void _showEditEmailMenu() {
    // 重置为当前值
    _emailController.text = _statusController.uEmail;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许底部菜单占满更多空间
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // 适配键盘
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '修改邮箱',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: '请输入新邮箱地址',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  // 自动聚焦
                  autofocus: true,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          // 取消操作
                          Navigator.of(context).pop();
                        },
                        child: Text('取消'),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {}, // async {
                        //   // 保存新邮箱
                        //   String newEmail = _emailController.text.trim();
                        //   // 简单的邮箱验证
                        //   if (_isValidEmail(newEmail) && newEmail != _statusController.uEmail) {
                        //     await _updateUserInfo('email', newEmail);
                        //   } else {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(content: Text('请输入有效的邮箱地址')),
                        //     );
                        //     return;
                        //   }
                        //   Navigator.of(context).pop();
                        // },
                        child: Text('保存'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
  }

  // 新增：验证邮箱格式
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  // 显示修改生日的底部菜单
  void _showEditBirthdayMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许底部菜单占满更多空间
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // 适配键盘
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '修改生日',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // 显示日期选择器
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), // 默认日期
                      firstDate: DateTime(1900), // 最早日期
                      lastDate: DateTime.now(), // 最晚日期
                    );

                    if (selectedDate != null) {
                      // 格式化日期为字符串
                      String formattedDate =
                          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

                      // 更新状态控制器中的生日
                      _selectedBirthday = formattedDate;

                      // 关闭底部菜单
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('选择日期'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () {
                    // 取消操作
                    Navigator.of(context).pop();
                  },
                  child: Text('取消'),
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
  }

  // 在_InfoPageState类中添加以下方法
  // 显示修改性别的底部菜单
  void _showEditGenderMenu() {
    // 重置为当前值
    _selectedGender = int.tryParse(_statusController.uGender) ?? 0;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '选择性别',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // 性别选择单选按钮组
                RadioGroup<int>(
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Row(children: [Radio<int>(value: 1), Text('男')]),
                      Row(children: [Radio<int>(value: 2), Text('女')]),
                      Row(children: [Radio<int>(value: 0), Text('保密')]),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          // 取消操作
                          Navigator.of(context).pop();
                        },
                        child: Text('取消'),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            () //async {
                            //   // 保存新性别
                            //   await _updateGender(_selectedGender.toString());
                            //   Navigator.of(context).pop();
                            // },
                            {},
                        child: Text('保存'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
  }

  //获取性别方法
  String getGenderText(int gender) {
    switch (gender) {
      case 1:
        return '男性';
      case 2:
        return '女性';
      default:
        return '保密';
    }
  }

  void _showEditRoleMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许底部菜单占满更多空间
      builder: (BuildContext context) {
        // 创建一个临时变量存储当前选择的身份
        Set<int> tempSelectedRoles = Set.from(
          _statusController.uRole.split(',').map(int.parse),
        );

        return SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // 适配键盘
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '修改个人身份',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: tempSelectedRoles.contains(1),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            tempSelectedRoles.add(1);
                          } else {
                            tempSelectedRoles.remove(1);
                          }
                        });
                      },
                    ),
                    Text('学生'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: tempSelectedRoles.contains(2),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            tempSelectedRoles.add(2);
                          } else {
                            tempSelectedRoles.remove(2);
                          }
                        });
                      },
                    ),
                    Text('老师'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          // 取消操作
                          Navigator.of(context).pop();
                        },
                        child: Text('取消'),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 保存选择的身份
                          _selectedRole = tempSelectedRoles.join(',');
                          Navigator.of(context).pop();
                        },
                        child: Text('保存'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
  }
}
