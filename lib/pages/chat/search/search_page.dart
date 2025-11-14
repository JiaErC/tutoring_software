import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import 'package:tutoring_software/bean/widgets/widgets_builder.dart';
import 'package:tutoring_software/modules/account_manager/account_match.dart';

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

  //是否已经搜索
  bool isSearched = false;

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
    list.add(const SizedBox(height: 20));
    list.add(
      Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 200,
          height: 80,
          child: Column(
            children: [
              const Text("你只需要填写其中的任意一个", style: TextStyle(fontSize: 12)),
              OutlinedButton.icon(
                onPressed: () {
                  if (_vaildateAccount()) {
                    debugPrint("输入正确");
                  } else {
                    debugPrint("输入错误");
                  }
                },
                icon: const Icon(Icons.app_registration),
                label: const Text('确定'),
              ),
            ],
          ),
        ),
      ),
    );
    return list;
  }

  //输入数据验证
  bool _vaildateAccount() {
    // 获取电话和邮箱输入值
    String phone = _userPhoneController.text.trim();
    String email = _userEmailController.text.trim();

    // 如果电话不为空，检查格式是否正确
    if (phone.isNotEmpty) {
      if (AccountMatch.isValidPhone(phone)) {
        return true;
      } else {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(const SnackBar(content: Text("电话格式输入错误")));
      }
    }
    // 如果邮箱不为空，检查格式是否正确
    if (email.isNotEmpty) {
      if (AccountMatch.isValidEmail(email)) {
        return true;
      } else {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(const SnackBar(content: Text("邮箱格式输入错误")));
      }
    }

    // 全部为空
    ScaffoldMessenger.of(
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(const SnackBar(content: Text("你什么都没有输入")));
    return false;
  }
}
