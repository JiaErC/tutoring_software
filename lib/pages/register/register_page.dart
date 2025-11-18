import "package:flutter/material.dart";
import "package:flutter_material_design_icons/flutter_material_design_icons.dart";
import "package:flutter_modular/flutter_modular.dart";
import 'package:flutter/scheduler.dart';

import 'package:tutoring_software/bean/widgets/widgets_builder.dart';
import 'register_controller.dart';
import 'package:tutoring_software/modules/user_data/user_data_controller.dart';
import 'package:tutoring_software/modules/user_data/user_data_item.dart';
import 'package:tutoring_software/modules/status/status_controller.dart';
import 'package:tutoring_software/modules/account_manager/account_controller.dart';
import 'package:tutoring_software/modules/account_manager/account_match.dart';
import 'package:tutoring_software/pages/subjects/subjects_controller.dart';

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
String uID = '';
int uGender = 0;
String uBirthday = '';
Set<int> uRole = {};
Map<String, dynamic> uTeachSubjects = {};
Map<String, dynamic> uStudySubjects = {};

class _RegisterPageState extends State<RegisterPage> {
  //引入注册控制器
  final RegisterController _registerController =
      Modular.get<RegisterController>();
  //引入用户数据控制器
  final UserDataController userDataController =
      Modular.get<UserDataController>();
  //引入状态控制器
  final StatusController statusController = Modular.get<StatusController>();
  //引入账号控制器
  final AccountController accountController = Modular.get<AccountController>();
  //添加学科选择界面控制实例
  final SubjectsController _subjectsController =
      Modular.get<SubjectsController>();
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
    _gender = _registerController.uGender;
    // 注册时候清空页面选择界面数据
    _subjectsController.registerInit();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在依赖项变化时（例如从其他页面返回）重新同步数据
    _syncControllerWithForm();
    accountController.clear();
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
    _usernameController.text = _registerController.uName;
    _emailController.text = _registerController.uEmail;
    _phoneController.text = _registerController.uPhone;
    _passwordController.text = _registerController.uPassword;
    _confirmPasswordController.text = _registerController.uConfirmPassword;
    _gender = _registerController.uGender;
    _selectedRoles = _registerController.uRole;
    _isTeachSelectedSubject = _subjectsController.teachSubjects.isNotEmpty;
    _isStudySelectedSubject = _subjectsController.studySubjects.isNotEmpty;
    uTeachSubjects = _subjectsController.teachSubjects;
    uStudySubjects = _subjectsController.studySubjects;
    uBirthday = _registerController.uBirthday;
  }

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
      _registerController.uEmail = value;
      _isEmailValid = AccountMatch.isValidEmail(value) || value.isEmpty;
      accountController.getUidByEmail(value);
    });
    // 检查邮箱唯一性
    if (_isEmailValid && value.isNotEmpty) {
      accountController.getUidByEmail(value).then((_) {
        if (accountController.uID.isNotEmpty) {
          // 使用SchedulerBinding添加post-frame回调来显示SnackBar
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('该邮箱已被注册')));
          });
        }
      });
    }
  }

  //验证电话号码
  void _validatePhone(String value) {
    setState(() {
      _registerController.uPhone = value;
      _isPhoneValid = AccountMatch.isValidPhone(value) || value.isEmpty;
      accountController.getUidByPhone(value);
    });
    // 检查电话号码唯一性
    if (_isPhoneValid && value.isNotEmpty) {
      accountController.getUidByPhone(value).then((_) {
        if (accountController.uID.isNotEmpty) {
          // 使用SchedulerBinding添加post-frame回调来显示SnackBar
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('该电话号码已被注册')));
          });
        }
      });
    }
  }

  // 验证用户名
  void _validateUsername(String value) {
    setState(() {
      _registerController.uName = value;
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
          _registerController.uPassword = value;
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

    // 验证邮箱和电话号码
    if ((!_isEmailValid || _emailController.text.isEmpty) &&
        (!_isPhoneValid || _phoneController.text.isEmpty)) {
      isValid = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入邮箱或者电话号码')));
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
    // 如果是学生角色，验证是否选择了学习科目
    if (_selectedRoles.contains(1) &&
        _subjectsController.studySubjects.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请选择学习科目')));
      return isValid;
    }
    // 如果是老师角色，验证是否选择了教学科目
    if (_selectedRoles.contains(2) &&
        _subjectsController.teachSubjects.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请选择教学科目')));
      return isValid;
    }

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
    uTeachSubjects = _subjectsController.teachSubjects;
    uStudySubjects = _subjectsController.studySubjects;
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
      final userDataItem = UserDataItem(
        uID: uID,
        uName: uName,
        uEmail: uEmail,
        uPhone: uPhone, // 修正：调整为正确的顺序
        uGender: uGender.toString(), // 修正：调整为正确的顺序
        uBirthday: uBirthday, // 修正：调整为正确的顺序
        uPassword: uPassword, // 修正：调整为正确的顺序
        uRole: uRole.toList().join(','),
        uTeachSubjects: uTeachSubjects,
        uStudySubjects: uStudySubjects,
      );
      // 登录状态设置更新
      // //查看登录状态
      // debugPrint("登录状态：${statusController.isLogin}\n登录用户ID：${statusController.uID}\n");
      // 显示成功消息
      //如果电话号码不为空
      if (uPhone.isNotEmpty) {
        try {
          final message = await accountController.savePhoneNumberUid(
            uPhone,
            uID,
          );
          // 处理成功情况
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        } catch (e) {
          // 处理错误情况
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
      //改为如果uEmail不为空
      if (uEmail.isNotEmpty) {
        try {
          final message = await accountController.saveEmailUid(uEmail, uID);
          // 处理成功情况
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        } catch (e) {
          // 处理错误情况
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
      await statusController.setStatus(userDataItem);
      // statusController.changePassword(uPassword);
      userDataController.saveUserData(userDataItem);
      // //打印UserDataItem来查看是否错误
      // debugPrint('这个是注册的数据，请看看有没有错误${userDataItem.toString()}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('注册成功！数据已保存。')));
      // 注册成功后，调用subjects_controller的init方法重新从status获取数据
      _subjectsController.init();
      Modular.to.pushReplacementNamed('/tab/my');
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
          onPressed: () {
            _subjectsController.init();
            Navigator.pop(context);
          }, // 返回上一级路由
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
                  _registerController.uGender = value!;
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
                            _registerController.uBirthday = uBirthday;
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
                            _registerController.uRole.add(1);
                          } else {
                            _selectedRoles.remove(1);
                            _registerController.uRole.remove(1);
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
                            _registerController.uRole.add(2);
                          } else {
                            _selectedRoles.remove(2);
                            _registerController.uRole.remove(2);
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
                debugPrint("点击了确定按钮\n");
                //表单验证
                if (_validateForm()) {
                  // 将表单数据赋值给用户属性
                  _assignFormDataToUserProperties();
                  // debugPrint('注册信息已收集完成');
                  // debugPrint('用户名: $uName');
                  // debugPrint('邮箱: $uEmail');
                  // debugPrint('电话号码: $uPhone');
                  // debugPrint('性别: $uGender');
                  // debugPrint('生日: $uBirthday');
                  // debugPrint('身份: $uRole');
                  // debugPrint('学习科目: $uStudySubjects');
                  // debugPrint('教学科目: $uTeachSubjects');
                  //如果注册的邮箱和电话号码存在，就不可以重复注册了
                  uID = await accountController.getUid();
                  if (accountController.uID.isNotEmpty) {
                    debugPrint("点击了确定，同时UID不为空\n");
                    // 调用保存用户数据到JSON文件的方法
                    await _saveUserData();
                    debugPrint(
                      "登录状态：${statusController.isLogin},\n 登录ID：${statusController.uID}",
                    );
                    setState(
                      () =>
                          //注册之后把注册页面清空
                          _registerController.clearAllData(),
                    );
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('注册失败，UID为空')));
                  }
                }
              },
              icon: const Icon(Icons.login),
              label: const Text('确定'),
            ),
          ),
          // _repeatedAccountPrompt(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 3. 修改_buildStudySubjects方法
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
        OutlinedButton.icon(
          onPressed: () async {
            await Modular.to.pushNamed(
              '/subjects',
              arguments: {'isTeacher': false},
            );
            setState(() {
              // 使用subjectsController替代registerController
              _isStudySelectedSubject =
                  _subjectsController.studySubjects.isNotEmpty;
              uStudySubjects = _subjectsController.studySubjects;
            });
          },
          icon: const Icon(MdiIcons.pencil),
          label: const Text('选择科目'),
        ),
        const SizedBox(width: 60),
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
        OutlinedButton.icon(
          onPressed: () async {
            await Modular.to.pushNamed(
              '/subjects',
              arguments: {'isTeacher': true},
            );
            setState(() {
              // 使用subjectsController替代registerController
              _isTeachSelectedSubject =
                  _subjectsController.teachSubjects.isNotEmpty;
              uTeachSubjects = _subjectsController.teachSubjects;
            });
          },
          icon: const Icon(MdiIcons.pen),
          label: const Text('选择科目'),
        ),
        const SizedBox(width: 60),
        _textPrompt(_isTeachSelectedSubject),
      ],
    );
  }

  //   Widget _repeatedAccountPrompt(BuildContext context) {
  //     if (accountController.uID.isNotEmpty) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(const SnackBar(content: Text('该邮箱或电话号码已被注册')));
  //     }
  //     return const SizedBox(height: 20);
  //   }
  // }
}
