import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/bean/widgets/widgets_builder.dart';
import 'package:tutoring_software/modules/user_data/user_data_controller.dart';
import 'package:tutoring_software/modules/account_manager/account_controller.dart';
import 'package:tutoring_software/modules/status/status_controller.dart';
import 'package:tutoring_software/modules/user_data/user_data_item.dart';
import 'package:tutoring_software/modules/account_manager/account_match.dart';
import 'package:tutoring_software/pages/subjects/subjects_controller.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

//用户的账号和密码
String uAccount = '';
String uPassword = '';

class _PasswordPageState extends State<PasswordPage> {
  //此处的代码仅作为测试
  UserDataController userDataController = Modular.get<UserDataController>();
  //通过邮箱和电话查找uID的控制类
  AccountController accountController = Modular.get<AccountController>();
  //登录状态控制器
  StatusController statusController = Modular.get<StatusController>();

  bool showPassword = false; //是否显示密码的变量
  //两个控制器
  final TextEditingController _userAccountController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  //添加学科控制器
  final SubjectsController subjectsController =
      Modular.get<SubjectsController>();

  //判断账号是否满足邮箱和手机号的格式
  bool _isAccountValid = true;
  //判断密码是否满足格式
  bool _isPasswordValid = true;
  // 密码正则表达式：至少包含一个数字、一个大写字母、一个小写字母和一个特殊字符
  final RegExp _passwordContainsDigit = RegExp(r'\d');
  final RegExp _passwordContainsUppercase = RegExp(r'[A-Z]');
  final RegExp _passwordContainsLowercase = RegExp(r'[a-z]');

  //验证账号
  void _validateAccount(String value) {
    // 在setState外部执行异步操作，避免UI卡顿
    _fetchUid(value);

    setState(() {
      if (AccountMatch.isValidEmail(value) ||
          AccountMatch.isValidPhone(value) ||
          value.isEmpty) {
        // 邮箱或手机号格式正确
        _isAccountValid = true;
      } else {
        // 邮箱或手机号格式不正确
        // 显示错误提示
        _isAccountValid = false;
      }
    });
  }

  //获取UID
  Future<void> _fetchUid(String value) async {
    try {
      if (AccountMatch.isValidPhone(value)) {
        await accountController.getUidByPhone(value);
      } else if (AccountMatch.isValidEmail(value)) {
        await accountController.getUidByEmail(value);
      }
      // 可以在这里添加额外的UI反馈，比如显示"验证成功"或清除错误提示
    } catch (e) {
      debugPrint('获取UID失败: $e');
      // 确保在发生错误时清空uID
      accountController.uID = '';
      // 可以添加UI反馈，比如显示错误消息
    }
  }

  //验证密码
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
    });
  }

  bool _validateForm() {
    bool isValid = true;
    // 验证账号
    if (!_isAccountValid || _userAccountController.text.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入有效的账号(邮箱/手机号)')));
      return isValid;
    }
    // 验证密码
    if (!_isPasswordValid || _userPasswordController.text.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('密码必须包含数字、大写字母和小写字母')));
      return isValid;
    }

    return isValid;
  }

  // 账号和密码的赋值
  void _assignFormDataToUserProperties() {
    uAccount = _userAccountController.text;
    uPassword = _userPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MediaQuery.of(context).orientation == Orientation.landscape
          ? Align(
              alignment: Alignment.center,
              child: SizedBox(width: 800, child: _loginByPassword(context)),
            )
          : _loginByPassword(context),
    );
  }

  /*以下代码来自PiliPuls*/
  Widget _loginByPassword(BuildContext context /*,ThemeData theme*/) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('使用账号密码登录'),
        const SizedBox(height: 10),
        buildProperty(
          TextField(
            controller: _userAccountController,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            onChanged: _validateAccount,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.account_box),
              border: const UnderlineInputBorder(),
              labelText: '账号',
              hintText: '邮箱/手机号',
              suffixIcon: IconButton(
                onPressed: () {
                  _userAccountController.clear();
                },
                icon: const Icon(Icons.clear),
              ),
              errorText: _isAccountValid ? null : '请输入正确的邮箱或手机号',
            ),
          ),
        ),
        buildProperty(
          TextField(
            obscureText: !showPassword,
            keyboardType: TextInputType.visiblePassword,
            onChanged: _validatePassword,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            controller: _userPasswordController,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.password),
              border: const UnderlineInputBorder(),
              labelText: '密码',
              suffixIcon: IconButton(
                onPressed: () {
                  _userPasswordController.clear();
                },
                icon: const Icon(Icons.clear),
              ),
              errorText: _isPasswordValid ? null : "你的密码格式不正确哟",
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 10),
            //点击即可显示密码
            Checkbox(
              value: showPassword,
              onChanged: (value) => setState(() => showPassword = value!),
            ),
            const Text('显示密码'),
            const Spacer(),
            TextButton(
              onPressed: () {
                //https://passport.bilibili.com/h5-app/passport/login/findPassword
                //https://passport.bilibili.com/passport/findPassword
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      clipBehavior: Clip.hardEdge,
                      title: const Text('忘记密码？'),
                      contentPadding: const EdgeInsets.fromLTRB(
                        0.0,
                        2.0,
                        0.0,
                        16.0,
                      ),
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
                          child: Text("试试扫码、手机号登录，或选择"),
                        ),
                        ListTile(
                          title: const Text('找回密码（手机版）'),
                          leading: const Icon(Icons.smartphone_outlined),
                          subtitle: const Text(
                            'https://passport.bilibili.com/h5-app/passport/login/findPassword',
                          ),
                          dense: false,
                          // onTap: () => Get
                          //   ..back()
                          //   ..toNamed(
                          //     '/webview',
                          //     parameters: {
                          //       'url':
                          //           'https://passport.bilibili.com/h5-app/passport/login/findPassword',
                          //       'type': 'url',
                          //       'pageTitle': '忘记密码',
                          //     },
                          //   ),
                          onTap: () => debugPrint("找回密码（手机版）"),
                        ),
                        ListTile(
                          title: const Text('找回密码（电脑版）'),
                          leading: const Icon(Icons.desktop_windows_outlined),
                          subtitle: const Text(
                            'https://passport.bilibili.com/pc/passport/findPassword',
                          ),
                          dense: false,
                          // onTap: () => Get
                          //   ..back()
                          //   ..toNamed(
                          //     '/webview',
                          //     parameters: {
                          //       'url':
                          //           'https://passport.bilibili.com/pc/passport/findPassword',
                          //       'type': 'url',
                          //       'pageTitle': '忘记密码',
                          //       'uaType': 'pc',
                          //     },
                          //   ),
                          onTap: () => debugPrint("找回密码（电脑版）"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('忘记密码'),
            ),
            const SizedBox(width: 20),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: () async {
                //表单验证
                if (_validateForm()) {
                  // 密码和账号的输出情况
                  _assignFormDataToUserProperties();
                  debugPrint("账号：$uAccount");
                  debugPrint("密码：$uPassword");
                  //验证用户账户查找情况
                  if (accountController.uID.isEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text("账号错误")));
                  } else {
                    try {
                      UserDataItem? userDataItem = await userDataController
                          .getUserData(accountController.uID);
                      if (userDataItem != null) {
                        //改变登录状态
                        statusController.setStatus(userDataItem);
                        // 添加changePassword方法调用，将密码同步到StatusController
                        // statusController.changePassword(uPassword);
                        // 调用SubjectsController的init()方法初始化科目数据
                        subjectsController.init();
                        debugPrint("登录成功:\n${userDataItem.toString()}");
                        //返回到上一个页面
                        Modular.to.pushReplacementNamed("/tab/my");
                        //同时更新
                      } else {
                        ScaffoldMessenger.of(
                          // ignore: use_build_context_synchronously
                          context,
                        ).showSnackBar(const SnackBar(content: Text("账号错误")));
                      }
                    } catch (e) {
                      // 捕获并处理"UID not found"等异常
                      debugPrint('登录异常: $e');
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("$e")));
                    }
                  }
                }
              },
              icon: const Icon(Icons.login),
              label: const Text('登录'),
            ),
            const SizedBox(width: 30),
            OutlinedButton.icon(
              onPressed: () => Modular.to.pushNamed("/register"),
              icon: const Icon(Icons.app_registration),
              label: const Text('注册'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        //结束语
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: Text(
        //     '根据 bilibili 官方登录接口规范，密码将在本地加盐、加密后传输。\n'
        //     '盐与公钥均由官方提供；以 RSA/ECB/PKCS1Padding 方式加密。\n'
        //     '账号密码仅用于该登录接口，不予保存；本地仅存储登录凭证。\n'
        //     '请务必在 PiliPlus 开源仓库等可信渠道下载安装。',
        //     textAlign: TextAlign.center,
        //     style: theme.textTheme.labelSmall!.copyWith(
        //       color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
