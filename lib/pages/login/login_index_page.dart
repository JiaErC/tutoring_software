import "package:flutter/material.dart";
import "package:tutoring_software/pages/login/login_tab.dart";

//加载登录的菜单
class LoginIndexPage extends StatefulWidget {
  const LoginIndexPage({super.key});

  @override
  State<LoginIndexPage> createState() => _LoginIndexPageState();
}

class _LoginIndexPageState extends State<LoginIndexPage> {
  @override
  Widget build(BuildContext context) {
    return LoginMenu();
  }
}