import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import 'package:tutoring_software/bean/widgets/widgets_builder.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //文本控制器，uID的，电话号码的，邮箱的
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _userPhoneController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(title: Text('搜索用户')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [..._searchFrame(context)],
        ),
      ),
    );
  }

  //添加搜索框架
  List<Widget> _searchFrame(BuildContext context) {
    List<Widget> list = [];
    //添加用户ID搜索框
    list.add(
      buildProperty(
        Container(
          margin: EdgeInsets.only(left: 50, right: 50, top: 10),
          child: TextField(
            keyboardType: TextInputType.number,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            controller: _userIDController,
            // autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              // 修改为圆角紫色边框
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              labelText: '用户ID',
              suffixIcon: IconButton(
                onPressed: () {
                  _userIDController.clear();
                },
                icon: const Icon(Icons.clear),
              ),
              // errorText: _isPasswordValid ? null : "你的密码格式不正确哟",
            ),
          ),
        ),
      ),
    );
    list.add(const SizedBox(height: 20));
    list.add(
      buildProperty(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            keyboardType: TextInputType.phone,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            controller: _userPhoneController,
            // autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone),
              // 修改为圆角紫色边框
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              labelText: '用户手机号',
              suffixIcon: IconButton(
                onPressed: () {
                  _userPhoneController.clear();
                },
                icon: const Icon(Icons.clear),
              ),
              // errorText: _isPasswordValid ? null : "你的密码格式不正确哟",
            ),
          ),
        ),
      ),
    );
    list.add(const SizedBox(height: 20));
    list.add(
      buildProperty(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            controller: _userEmailController,
            // autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              // 修改为圆角紫色边框
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              labelText: '用户邮箱',
              suffixIcon: IconButton(
                onPressed: () {
                  _userEmailController.clear();
                },
                icon: const Icon(Icons.clear),
              ),
              // errorText: _isPasswordValid ? null : "你的密码格式不正确哟",
            ),
          ),
        ),
      ),
    );
    list.add(const SizedBox(height: 60));
    list.add(
      OutlinedButton.icon(
        onPressed: () => debugPrint('确定搜索'),
        icon: const Icon(Icons.app_registration),
        label: const Text('确定'),
      ),
    );
    return list;
  }
}
