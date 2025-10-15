import "package:flutter/material.dart";

//加载登录的菜单
class SmsPage extends StatefulWidget {
  const SmsPage({super.key});

  @override
  State<SmsPage> createState() => _SmsPageState();
}

class _SmsPageState extends State<SmsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Text('Sms page', textAlign: TextAlign.center),
    );
  }
}
