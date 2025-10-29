import "package:flutter/material.dart";
import "package:flutter_material_design_icons/flutter_material_design_icons.dart";
import "package:flutter_modular/flutter_modular.dart";

import 'package:tutoring_software/bean/widgets/widgets_builder.dart';
import 'register_controller.dart';
import 'package:tutoring_software/modules/user_data/user_data_controller.dart';
import 'package:tutoring_software/modules/user_data/user_data_item.dart';
import 'package:tutoring_software/modules/status/status_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

//定义性别 0 保密，1：男，2：女
int? _gender = 0;
//选择学生还是老师，也就是应用的身份，1：学生，2：老师
Set<int> _selectedRoles = {};
//是否选择了学科，老师的和学生的
bool _isTeachSelectedSubject = false;
bool _isStudySelectedSubject = false;

//用户的属性
String uName = '';
String uEmail = '';
String uPhone = '';
String uPassword = '';
int uGender = 0;
String uBirthday = '';
Set<int> uRole = {};
Map<String, dynamic> uTeachSubjects = {};
Map<String, dynamic> uStudySubjects = {};

class _RegisterPageState extends State<RegisterPage> {
  //引入注册控制器
  final RegisterController controller = Modular.get<RegisterController>();
  //引入用户数据控制器
  final UserDataController userDataController =
      Modular.get<UserDataController>();
  //引入状态控制器
  final StatusController statusController = Modular.get<StatusController>();
  //创建一个是否横屏的显示器
  bool _isLandscape = false;

  //引入各个输入框的控制器
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  //添加邮箱和电话的验证状态
  bool _isEmailValid = true;
  bool _isPhoneValid = true;
  // 添加用户名和密码的验证状态
  bool _isUsernameValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;

  @override
  void initState() {
    super.initState();
    // 初始化时同步数据
    _syncControllerWithForm();
    _gender = controller.uGender;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在依赖项变化时（例如从其他页面返回）重新同步数据
    _syncControllerWithForm();
  }

  //组件销毁的时候的提示
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 用于同步控制器和表单数据
  void _syncControllerWithForm() {
    _usernameController.text = controller.uName;
    _emailController.text = controller.uEmail;
    _phoneController.text = controller.uPhone;
    _passwordController.text = controller.uPassword;
    _confirmPasswordController.text = controller.uConfirmPassword;
    _gender = controller.uGender;
    _selectedRoles = controller.uRole;
    _isTeachSelectedSubject = controller.uTeachSubjects.isNotEmpty;
    _isStudySelectedSubject = controller.uStudySubjects.isNotEmpty;
    uBirthday = controller.uBirthday;
  }

  //邮箱正则表达式
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  //电话号码正则表达式（中国手机号）
  final RegExp _phoneRegex = RegExp(r'^1[3-9]\d{9}$');
  // 用户名正则表达式：2-30个任意字符
  final RegExp _usernameRegex = RegExp(r'^.{2,30}$');
  // 密码正则表达式：至少包含一个数字、一个大写字母、一个小写字母和一个特殊字符
  final RegExp _passwordContainsDigit = RegExp(r'\d');
  final RegExp _passwordContainsUppercase = RegExp(r'[A-Z]');
  final RegExp _passwordContainsLowercase = RegExp(r'[a-z]');
  // final RegExp _passwordContainsSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]+-/');

  //验证邮箱
  void _validateEmail(String value) {
    setState(() {
      controller.uEmail = value;
      _isEmailValid = _emailRegex.hasMatch(value) || value.isEmpty;
    });
  }

  //验证电话号码
  void _validatePhone(String value) {
    setState(() {
      controller.uPhone = value;
      _isPhoneValid = _phoneRegex.hasMatch(value) || value.isEmpty;
    });
  }

  // 验证用户名
  void _validateUsername(String value) {
    setState(() {
      controller.uName = value;
      _isUsernameValid = _usernameRegex.hasMatch(value) || value.isEmpty;
    });
  }

  // 验证密码
  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _isPasswordValid = true;
      } else {
        _isPasswordValid =
            _passwordContainsDigit.hasMatch(value) &&
            _passwordContainsUppercase.hasMatch(value) &&
            _passwordContainsLowercase.hasMatch(value);
      }

      // 同时验证确认密码是否与密码一致
      _validateConfirmPassword(_confirmPasswordController.text);
    });
  }

  // 验证确认密码
  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty || _passwordController.text.isEmpty) {
        _isConfirmPasswordValid = true;
      } else {
        _isConfirmPasswordValid = value == _passwordController.text;
        if (_isConfirmPasswordValid) {
          controller.uPassword = value;
        }
      }
    });
  }

  // 表单验证方法
  bool _validateForm() {
    bool isValid = true;

    // 验证用户名
    if (!_isUsernameValid || _usernameController.text.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入有效的用户名(2-30个字符)')));
      return isValid;
    }

    // 验证邮箱
    if (!_isEmailValid || _emailController.text.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入有效的邮箱地址')));
      return isValid;
    }

    // 验证电话号码
    if (!_isPhoneValid || _phoneController.text.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入有效的手机号码')));
      return isValid;
    }

    // 验证密码
    if (!_isPasswordValid || _passwordController.text.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('密码必须包含数字、大写字母和小写字母')));
      return isValid;
    }

    // 验证确认密码
    if (!_isConfirmPasswordValid || _confirmPasswordController.text.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('两次输入的密码不一致')));
      return isValid;
    }

    // 验证身份选择
    if (_selectedRoles.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请选择您的身份（学生/老师）')));
      return isValid;
    }

    // // 验证学科选择（如果选择了学生或老师身份）
    // if (_selectedRoles.contains(1) && !_isStudySelectedSubject) {
    //   isValid = false;
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text('请选择学习科目')));
    //   return isValid;
    // }

    // if (_selectedRoles.contains(2) && !_isTeachSelectedSubject) {
    //   isValid = false;
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text('请选择教学科目')));
    //   return isValid;
    // }

    return isValid;
  }

  // 将表单数据赋值给用户属性
  void _assignFormDataToUserProperties() {
    // 赋值基本信息
    uName = _usernameController.text;
    uEmail = _emailController.text;
    uPhone = _phoneController.text;
    uPassword = _passwordController.text;
    // 赋值性别（转换为非空类型）
    uGender = _gender ?? 0;
    // 赋值身份
    uRole = Set.from(_selectedRoles); // 创建一个新的Set以避免引用问题
  }

  //这个是选择学科的提示
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
                '请选择学科',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
  }

  // 在_RegisterPageState类中添加保存用户数据到JSON文件的方法
  Future<void> _saveUserData() async {
    try {
      final String uid = DateTime.now().millisecondsSinceEpoch.toString();
      final userDataItem = UserDataItem(
        uID: uid,
        uName: uName,
        uEmail: uEmail,
        uPassword: uPassword,
        uPhone: uPhone,
        uBirthday: uBirthday,
        uGender: uGender.toString(), // 转换为字符串
        uRole: uRole.toList().join(','), // 转换为逗号分隔的字符串
        uTeachSubjects: uTeachSubjects,
        uStudySubjects: uStudySubjects,
      );
      userDataController.saveUserData(userDataItem);
      // 登录状态设置为true
      statusController.addStatus(uid);
      // //查看登录状态
      // debugPrint("登录状态：${statusController.isLogin}\n登录用户ID：${statusController.uID}\n");
      // 显示成功消息
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('注册成功！数据已保存。')));
      // 注册成功后导航到登录页面或首页
      Modular.to.pushReplacementNamed('/login');
    } catch (e) {
      print('保存用户数据失败: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('注册失败，请重试。')));
    }
  }

  @override
  Widget build(BuildContext context) {
    _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      // 添加返回按钮
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 返回上一级路由
        ),
        title: const Text('注册'), // 设置页面标题
      ),
      backgroundColor: Colors.white,
      body: _isLandscape
          ? Align(alignment: Alignment.center, child: _buildRegister(context))
          : _buildRegister(context),
    );
  }

  Widget _buildRegister(BuildContext context) {
    //返回注册的各个项目
    return SingleChildScrollView(
      padding: _isLandscape
          ? const EdgeInsets.symmetric(horizontal: 150)
          : const EdgeInsets.all(0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text('注册账户'),
          const SizedBox(height: 10),
          //写入用户名
          buildProperty(
            TextField(
              controller: _usernameController,
              onChanged: _validateUsername,
              decoration: InputDecoration(
                prefixIcon: const Icon(MdiIcons.account),
                border: const UnderlineInputBorder(),
                labelText: '用户名',
                suffixIcon: IconButton(
                  onPressed: () => _usernameController.clear(),
                  icon: const Icon(Icons.clear),
                ),
                errorText: !_isUsernameValid ? '用户名长度应为2-30个字符' : null,
              ),
            ),
          ),
          //写入email
          buildProperty(
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: _validateEmail,
              decoration: InputDecoration(
                prefixIcon: const Icon(MdiIcons.email),
                border: const UnderlineInputBorder(),
                labelText: '邮箱',
                suffixIcon: IconButton(
                  onPressed: () => _emailController.clear(),
                  icon: const Icon(Icons.clear),
                ),
                errorText: !_isEmailValid ? '请输入有效的邮箱地址' : null,
              ),
            ),
          ),
          //写入电话号码
          buildProperty(
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onChanged: _validatePhone,
              decoration: InputDecoration(
                prefixIcon: const Icon(MdiIcons.phone),
                border: const UnderlineInputBorder(),
                labelText: '电话号码',
                suffixIcon: IconButton(
                  onPressed: () => _phoneController.clear(),
                  icon: const Icon(Icons.clear),
                ),
                errorText: !_isPhoneValid ? '请输入有效的手机号码' : null,
              ),
            ),
          ),
          //两次写入密码
          buildProperty(
            TextField(
              controller: _passwordController,
              onChanged: _validatePassword,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(MdiIcons.lock),
                border: const UnderlineInputBorder(),
                labelText: '密码',
                suffixIcon: IconButton(
                  onPressed: () => _passwordController.clear(),
                  icon: const Icon(Icons.clear),
                ),
                errorText: !_isPasswordValid ? '密码必须包含数字、大写字母、小写字母' : null,
              ),
            ),
          ),
          buildProperty(
            TextField(
              controller: _confirmPasswordController,
              onChanged: _validateConfirmPassword,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(MdiIcons.lock),
                border: const UnderlineInputBorder(),
                labelText: '确认密码',
                suffixIcon: IconButton(
                  onPressed: () => _confirmPasswordController.clear(),
                  icon: const Icon(Icons.clear),
                ),
                errorText: !_isConfirmPasswordValid ? '两次输入的密码不一致' : null,
              ),
            ),
          ),
          //性别选择
          buildProperty(
            RadioGroup<int>(
              groupValue: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value;
                  controller.uGender = value!;
                  debugPrint('性别：$_gender');
                });
              },
              child: Row(
                children: <Widget>[
                  const Icon(MdiIcons.genderMaleFemale),
                  const SizedBox(width: 10),
                  const Text(
                    '性别',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  Radio<int>(value: 1),
                  const Text('男'),
                  Radio<int>(value: 2),
                  const Text('女'),
                  Radio<int>(value: 0),
                  const Text('保密'),
                ],
              ),
            ),
          ),
          //接下来是生日信息
          buildProperty(
            Row(
              children: [
                const Icon(MdiIcons.cake),
                const SizedBox(width: 10),
                const Text(
                  '生日',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(width: 60),
                //选择出生日期
                SizedBox(
                  width: 200,
                  child:
                      //选择年、月、日
                      OutlinedButton.icon(
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(
                              2000,
                              1,
                              1,
                            ), // 初始选中日期，例如2000年1月1日
                            firstDate: DateTime(1900), // 允许选择的最早日期
                            lastDate: DateTime.now(), // 允许选择的最晚日期（今天）
                            helpText: '选择您的生日', // 自定义对话框标题
                            cancelText: '取消', // 自定义取消按钮文字
                            confirmText: '确定', // 自定义确认按钮文字
                          );

                          if (pickedDate != null) {
                            // 将选择的日期保存到用户属性
                            uBirthday =
                                '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                            controller.uBirthday = uBirthday;
                            debugPrint("选择的生日是: $uBirthday");
                          }
                        },
                        icon: const Icon(MdiIcons.calendar),
                        label: const Text('选择生日'),
                      ),
                ),
              ],
            ),
          ),
          //选择学生还是老师，也就是应用的身份，1：学生，2：老师
          buildProperty(
            Row(
              children: <Widget>[
                const Icon(MdiIcons.accountCog),
                const SizedBox(width: 10),
                const Text(
                  '身份',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
                // 替换为Checkbox组件
                Row(
                  children: [
                    Checkbox(
                      value: _selectedRoles.contains(1),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedRoles.add(1);
                            controller.uRole.add(1);
                          } else {
                            _selectedRoles.remove(1);
                            controller.uRole.remove(1);
                          }
                          debugPrint('选中的身份：$_selectedRoles');
                        });
                      },
                    ),
                    const Text('学生'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _selectedRoles.contains(2),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedRoles.add(2);
                            controller.uRole.add(2);
                          } else {
                            _selectedRoles.remove(2);
                            controller.uRole.remove(2);
                          }
                          debugPrint('选中的身份：$_selectedRoles');
                        });
                      },
                    ),
                    const Text('老师'),
                  ],
                ),
              ],
            ),
          ),
          //当用户选择了学生身份的时候
          //显示这个组件，用来选择学习的科目
          if (_selectedRoles.contains(1))
            buildProperty(_buildStudySubjects(context)),
          //当用户选择了老师身份的时候
          //显示这个组件，用来选择教学的科目
          if (_selectedRoles.contains(2))
            buildProperty(_buildTeachSubjects(context)),
          const SizedBox(height: 20),
          //确定按钮
          Center(
            child: OutlinedButton.icon(
              onPressed: () async {
                //表单验证
                if (_validateForm()) {
                  // 将表单数据赋值给用户属性
                  _assignFormDataToUserProperties();
                  debugPrint('注册信息已收集完成');
                  debugPrint('用户名: $uName');
                  debugPrint('邮箱: $uEmail');
                  debugPrint('电话号码: $uPhone');
                  debugPrint('性别: $uGender');
                  debugPrint('生日: $uBirthday');
                  debugPrint('身份: $uRole');
                  debugPrint('学习科目: $uStudySubjects');
                  debugPrint('教学科目: $uTeachSubjects');
                  // 调用保存用户数据到JSON文件的方法
                  await _saveUserData();
                  debugPrint("登录状态：${statusController.isLogin},\n 登录ID：${statusController.uID}");
                }
              },
              icon: const Icon(Icons.login),
              label: const Text('确定'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  //跳转到选择学习科目的界面
  Widget _buildStudySubjects(BuildContext context) {
    return Row(
      children: [
        const Icon(MdiIcons.bookOpen),
        const SizedBox(width: 10),
        const Text(
          "选择学习科目",
          style: TextStyle(fontSize: 12, color: Colors.black87),
        ),
        const SizedBox(width: 60),
        //跳转到选择科目的界面
        OutlinedButton.icon(
          onPressed: () async {
            final result = await Modular.to.pushNamed(
              '/subjects',
              arguments: {'isTeacher': false},
            );
            if (result != null && result is Map<String, dynamic>) {
              setState(() {
                _isStudySelectedSubject = result.isNotEmpty;
                uStudySubjects = result;
                controller.uStudySubjects = result;
              });
            }
          },
          icon: const Icon(MdiIcons.pencil),
          label: const Text('选择科目'),
        ),
        const SizedBox(width: 60),
        //提示框，提示是否选择了学科
        _textPrompt(_isStudySelectedSubject),
      ],
    );
  }

  //跳转到选择教学科目的界面
  Widget _buildTeachSubjects(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.book),
        const SizedBox(width: 10),
        const Text(
          "选择教学科目",
          style: TextStyle(fontSize: 12, color: Colors.black87),
        ),
        const SizedBox(width: 60),
        //跳转到选择科目的界面
        OutlinedButton.icon(
          onPressed: () async {
            // 使用await等待返回结果
            final result = await Modular.to.pushNamed(
              '/subjects',
              arguments: {'isTeacher': true},
            );
            // 检查是否有返回数据
            if (result != null && result is Map<String, dynamic>) {
              // 更新状态，表示已选择学科
              setState(() {
                _isTeachSelectedSubject = result.isNotEmpty;
                uTeachSubjects = result;
                controller.uTeachSubjects = result;
              });
            }
          },
          icon: const Icon(MdiIcons.pen),
          label: const Text('选择科目'),
        ),
        const SizedBox(width: 60),
        //提示框，提示是否选择了学科
        _textPrompt(_isTeachSelectedSubject),
      ],
    );
  }
}
