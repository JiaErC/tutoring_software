import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:getwidget/getwidget.dart';

import 'package:tutoring_software/modules/api/api_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            GFButton(
              text: "获取UID",
              onPressed: () async {
                // 1. 将回调标记为 async
                try {
                  ApiController apiController = Modular.get<ApiController>();
                  // 2. 使用 await 等待异步操作完成
                  String result = await apiController.getUid();
                  // 3. 只有在获取到结果后才调用 setState 更新UI
                  setState(() {
                    uid = result;
                  });
                } catch (e) {
                  // 4. 添加错误处理，防止应用崩溃
                  print("获取UID失败: $e");
                  // 5. 显示错误提示给用户
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("获取UID失败: $e")));
                }
              },
            ),
            Text(uid),
          ],
        ),
      ),
    );
  }
}
