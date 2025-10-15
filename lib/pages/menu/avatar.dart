import "package:flutter/material.dart";

//用于管理和处理用户的头像
class PersonAvatar extends StatelessWidget {
  const PersonAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("点击头像");
      },
      child: CircleAvatar(
        backgroundImage: AssetImage("lib/data/images/1.png"),
        radius: 20,
      ),
    );
  }
}
