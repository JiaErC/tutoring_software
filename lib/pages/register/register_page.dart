import "package:flutter/material.dart";
import "package:flutter_material_design_icons/flutter_material_design_icons.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 添加返回按钮
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 返回上一级路由
        ),
        title: const Text('注册'), // 设置页面标题
      ),
      body: MediaQuery.of(context).orientation == Orientation.landscape
          ? Align(
              alignment: Alignment.center,
              child: SizedBox(width: 800, child: _buildRegister(context)),
            )
          : _buildRegister(context),
    );
  }

  Widget _buildRegister(BuildContext context) {
    //返回注册的各个项目
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('注册账户'),
        const SizedBox(height: 10),
        //写入用户名
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            // controller: _loginPageCtr.usernameTextController,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            decoration: InputDecoration(
              prefixIcon: const Icon(MdiIcons.account),
              border: const UnderlineInputBorder(),
              labelText: '用户名',
              // hintText: '邮箱/手机号',
              suffixIcon: IconButton(
                onPressed: () => debugPrint("清空用户名"),
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        ),
        //写入email
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            // controller: _loginPageCtr.usernameTextController,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            decoration: InputDecoration(
              prefixIcon: const Icon(MdiIcons.email),
              border: const UnderlineInputBorder(),
              labelText: '邮箱',
              // hintText: '邮箱/手机号',
              suffixIcon: IconButton(
                onPressed: () => debugPrint("清空邮箱"),
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        ),
        //写入电话号码
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            // controller: _loginPageCtr.usernameTextController,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            decoration: InputDecoration(
              prefixIcon: const Icon(MdiIcons.phone),
              border: const UnderlineInputBorder(),
              labelText: '电话号码',
              // hintText: '邮箱/手机号',
              suffixIcon: IconButton(
                onPressed: () => debugPrint("清空电话号码"),
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        ),
        //两次写入密码
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            // controller: _loginPageCtr.usernameTextController,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            decoration: InputDecoration(
              prefixIcon: const Icon(MdiIcons.lock),
              border: const UnderlineInputBorder(),
              labelText: '密码',
              // hintText: '邮箱/手机号',
              suffixIcon: IconButton(
                onPressed: () => debugPrint("清空密码"),
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            // controller: _loginPageCtr.usernameTextController,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            decoration: InputDecoration(
              prefixIcon: const Icon(MdiIcons.lock),
              border: const UnderlineInputBorder(),
              labelText: '请再次输入密码',
              // hintText: '邮箱/手机号',
              suffixIcon: IconButton(
                onPressed: () => debugPrint("清空密码"),
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
