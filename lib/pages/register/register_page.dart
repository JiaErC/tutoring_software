import "package:flutter/material.dart";

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
      body: const Align(alignment: Alignment.center, child: Text("注册页面")),
    );
  }
}
