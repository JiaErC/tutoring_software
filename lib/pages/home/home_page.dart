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
              onPressed: () {
                setState(() {
                  ApiController apiController = Modular.get<ApiController>();
                  uid = apiController.getUid() as String;
                });
              },
            ),
            Text(uid),
          ],
        ),
      ),
    );
  }
}
