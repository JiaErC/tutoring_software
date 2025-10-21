import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  bool showPassword = false; //是否显示密码的变量

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            // controller: _loginPageCtr.usernameTextController,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.account_box),
              border: const UnderlineInputBorder(),
              labelText: '账号',
              hintText: '邮箱/手机号',
              suffixIcon: IconButton(
                onPressed: () => debugPrint("清空用户写入账号的内容"),
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            obscureText: !showPassword,
            keyboardType: TextInputType.visiblePassword,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            // controller: _loginPageCtr.passwordTextController,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.password),
              border: const UnderlineInputBorder(),
              labelText: '密码',
              suffixIcon: IconButton(
                onPressed: () => debugPrint("清空用户写入密码的内容"),
                icon: const Icon(Icons.clear),
              ),
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
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () => debugPrint("登录"),
                icon: const Icon(Icons.login),
                label: const Text('登录'),
              ),
              const SizedBox(width: 20),
              //注册按钮，
              OutlinedButton.icon(
                onPressed: () => Modular.to.pushNamed('/register'),
                icon: const Icon(Icons.login),
                label: const Text('注册'),
              ),
            ],
          ),
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
