import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/services.dart';

import 'package:tutoring_software/modules/status/status_controller.dart';
import 'package:tutoring_software/modules/user_data/user_data_controller.dart';
import 'package:tutoring_software/modules/account_manager/account_controller.dart';
import 'package:tutoring_software/modules/account_manager/account_match.dart';
import 'package:tutoring_software/bean/data_process/json_process.dart';
import 'package:tutoring_software/pages/subjects/subjects_controller.dart';

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
  //引入账号控制器
  final AccountController _accountController = Modular.get<AccountController>();
  //引入学科页面控制类来监视学科选择信息
  final SubjectsController _subjectsController =
      Modular.get<SubjectsController>();

  // 添加TextEditingController用于处理输入
  late TextEditingController _userNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  //获取到的签名
  String _newSignature = "";

  //用于检测更新变量的一些变量
  int? _selectedGender;
  String? _selectedBirthday;
  //存放选择身份的变量
  // 创建一个临时变量存储当前选择的身份
  Set<int>? _tempSelectedRoles;

  //新的用户名、电话和邮箱
  late String _newUserName;
  late String _newPhone;
  late String _newEmail;
  //新的性别
  int? _newGender;
  String? _newRole;
  String? _newBirthday;
  //新的学科
  Map<String, dynamic>? _newStudySubjects;
  Map<String, dynamic>? _newTeachSubjects;

  @override
  void initState() {
    super.initState();
    // 初始化控制器，设置默认值
    _userNameController = TextEditingController(text: _statusController.uName);
    _phoneController = TextEditingController(text: _statusController.uPhone);
    _emailController = TextEditingController(text: _statusController.uEmail);
    //初始化电话号码和邮箱
    _newUserName = _statusController.uName;
    _newPhone = _statusController.uPhone;
    _newEmail = _statusController.uEmail;

    // 初始化出生日期选择值    初始化性别选择值
    _selectedBirthday = _statusController.uBirthday;
    _newGender = int.tryParse(_statusController.uGender) ?? 0;
    // 初始化角色选择值
    _newRole = _statusController.uRole;
    _selectedGender = _newGender;
    _newBirthday = _selectedBirthday ?? "未设置生日";
    _tempSelectedRoles = Set.from(
      _statusController.uRole.split(',').map(int.parse),
    );
    _tempSelectedRoles ??= {1, 2};

    //初始化学科
    _newStudySubjects = deepCopyMap(_statusController.uStudySubjects);
    _newTeachSubjects = deepCopyMap(_statusController.uTeachSubjects);

    debugPrint("info_page.dart 初始化界面");
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
                //签名区域
                _buildEditTile(
                  Icons.edit_note,
                  _newSignature,
                  "签名",
                  _showEditSignatureMenu,
                ),
                _buildDivider(),
                //修改用户名、电话号码、邮箱
                _buildEditTile(
                  Icons.person,
                  _newUserName,
                  "用户名",
                  _showEditUserNameMenu,
                ),
                _buildDivider(),
                //修改电话号码
                _buildEditTile(
                  Icons.phone,
                  _newPhone,
                  "电话号码",
                  _showEditPhoneMenu,
                ),
                _buildDivider(),
                //修改邮箱
                _buildEditTile(
                  Icons.email,
                  _newEmail,
                  "邮箱",
                  _showEditEmailMenu,
                ),
                _buildDivider(),
                //修改生日
                _buildEditTile(
                  Icons.calendar_today,
                  _newBirthday!,
                  "生日",
                  _showEditBirthdayMenu,
                ),
                _buildDivider(),
                //性别信息
                _buildEditTile(
                  Icons.wc,
                  getGenderText(_newGender!),
                  "性别",
                  _showEditGenderMenu,
                ),
                _buildDivider(),
                //个人身份
                _buildEditTile(
                  Icons.people,
                  getRoleText(_newRole!),
                  "个人身份",
                  _showEditRoleMenu,
                ),
                _buildDivider(),
                const SizedBox(height:20),
                if (_tempSelectedRoles?.contains(1) ?? false)
                  _buildEditStudySubjects(context), // 学生更改学科区域
                const SizedBox(height:10),
                if (_tempSelectedRoles?.contains(2) ?? false)
                  _buildEditTeachSubjects(context), // 老师更改学科区域
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
                const SizedBox(width: 20),
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

  void _showEditSignatureMenu() {
    // 初始化签名输入框
    TextEditingController _signatureController = TextEditingController(
      text: _statusController.uSignature ?? '',
    );
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
                  '修改签名',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _signatureController,
                  decoration: InputDecoration(
                    labelText: '请输入新签名',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100, // 限制签名长度为50个字符
                  minLines: 5,
                  maxLines: 10000,
                  autofocus: true, // 自动聚焦
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
                          _newSignature = _signatureController.text;
                          if (_newSignature.isNotEmpty) {
                            // 如果签名不为空，保存并关闭弹窗
                            setState(() {
                              _statusController.uSignature = _newSignature;
                            });
                            Navigator.of(context).pop();
                          } else {
                            // 如果签名为空，显示错误提示
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('签名不能为空'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
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
                        onPressed: () {
                          String newUserName = _userNameController.text.trim();
                          if (AccountMatch.isValidUsername(newUserName)) {
                            // 如果用户名格式正确，保存并关闭弹窗
                            setState(() {
                              _newUserName = newUserName;
                            });
                            Navigator.of(context).pop();
                          } else {
                            // 如果用户名格式不正确，显示错误提示
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '请输入有效的用户名（2-30个字符，仅支持字母、数字、下划线和中文）',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
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
                        onPressed: () {
                          String newPhone = _phoneController.text.trim();
                          if (AccountMatch.isValidPhone(newPhone)) {
                            // 如果电话号码格式正确，保存并关闭弹窗
                            setState(() {
                              _newPhone = newPhone;
                            });
                            Navigator.of(context).pop();
                          } else {
                            // 如果电话号码格式不正确，显示错误提示
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('请输入有效的电话号码'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
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
                        onPressed: () {
                          String newEmail = _emailController.text.trim();
                          if (AccountMatch.isValidEmail(newEmail)) {
                            // 如果邮箱格式正确，保存并关闭弹窗
                            setState(() {
                              _newEmail = newEmail;
                            });
                            Navigator.of(context).pop();
                          } else {
                            // 如果邮箱格式不正确，显示错误提示
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('请输入有效的邮箱地址'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
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
                      setState(
                        () =>
                            // 更新状态控制器中的生日
                            _newBirthday = formattedDate,
                      );
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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // 使用StatefulBuilder来管理模态框内部的状态
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '选择性别',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // 按照注册页面的方式使用RadioGroup
                    RadioGroup<int>(
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        // 使用setModalState而不是setState来更新模态框内的状态
                        setModalState(() {
                          _selectedGender = value;
                          debugPrint("info_page.dart选择的性别值：$_selectedGender");
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
                              Navigator.of(context).pop();
                            },
                            child: Text('取消'),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // 保存时使用主页面的setState更新状态
                              setState(() {
                                _newGender = _selectedGender;
                              });
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
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      enableDrag: true,
    );
  }

  //获取性别方法
  String getGenderText(int? gender) {
    if (gender == null) {
      _newGender = 0;
      return '保密';
    }
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
        // 使用StatefulBuilder来管理模态框内部的状态
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _tempSelectedRoles?.contains(1),
                          onChanged: (bool? value) {
                            // 使用setModalState更新模态框内的状态
                            setModalState(() {
                              if (value == true) {
                                _tempSelectedRoles?.add(1);
                              } else {
                                _tempSelectedRoles?.remove(1);
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
                          value: _tempSelectedRoles?.contains(2),
                          onChanged: (bool? value) {
                            // 使用setModalState更新模态框内的状态
                            setModalState(() {
                              if (value == true) {
                                _tempSelectedRoles?.add(2);
                              } else {
                                _tempSelectedRoles?.remove(2);
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
                              // 保存选择的身份，使用主页面的setState更新状态
                              setState(() {
                                _newRole = _tempSelectedRoles?.join(',') ?? '';
                              });
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

  //角色展示方法
  String getRoleText(String? role) {
    if (role == null || role.isEmpty) {
      return '未设置身份';
    }
    // 将角色字符串拆分为整数集合
    Set<int> roles = role.split(',').map(int.parse).toSet();
    // 根据角色集合返回对应的文本
    if (roles.contains(1) && roles.contains(2)) {
      return '老师和学生';
    } else if (roles.contains(1)) {
      return '学生';
    } else if (roles.contains(2)) {
      return '老师';
    } else {
      return '未设置身份';
    }
  }

  // 老师更改学科区域
  Widget _buildEditTeachSubjects(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.book),
        const SizedBox(width: 10),
        const Text(
          "修改教学科目",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(width: 60),
        // 跳转到选择科目的界面
        OutlinedButton.icon(
          onPressed: () async {
            await Modular.to.pushNamed(
              '/subjects',
              arguments: {'isTeacher': true}, // 传递参数，表示是老师身份
            );
            // 更新状态，表示已选择学科
            setState(() {
              _newRole = _statusController.uRole;
              // _statusController.uTeachSubjects = _userDataController.uTeachSubjects;
            });
          },
          icon: const Icon(Icons.edit),
          label: const Text('修改科目'),
        ),
        const SizedBox(width: 60),
        // 提示框，提示是否选择了学科
        _textPrompt(_statusController.uTeachSubjects.isNotEmpty),
      ],
    );
  }

  // 学生更改学科区域
  Widget _buildEditStudySubjects(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.school),
        const SizedBox(width: 10),
        const Text(
          "修改学习科目",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(width: 60),
        // 跳转到选择科目的界面
        OutlinedButton.icon(
          onPressed: () async {
            await Modular.to.pushNamed(
              '/subjects',
              arguments: {'isTeacher': false}, // 传递参数，表示是学生身份
            );
            // 更新状态，表示已选择学科
            setState(() {
              _newRole = _statusController.uRole;
              // _statusController.uStudySubjects = _newStudySubjects;
            });
          },
          icon: const Icon(Icons.edit),
          label: const Text('修改科目'),
        ),
        const SizedBox(width: 60),
        // 提示框，提示是否选择了学科
        _textPrompt(_statusController.uStudySubjects.isNotEmpty),
      ],
    );
  }

  // 提示框组件
  Widget _textPrompt(bool isSelected) {
    return isSelected
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                '已选择学科',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                '未选择学科',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
  }
}
