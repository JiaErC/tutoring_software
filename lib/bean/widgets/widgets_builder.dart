import 'package:flutter/material.dart';

//定义属性类
Widget buildProperty(Widget c) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: c,
  );
}

//取消和确定按钮
Widget buildCancelAndConfirmButton(VoidCallback f1, VoidCallback f2, {BuildContext? context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          onPressed: f1,
          child: Text('取消'),
        ),
      ),
      SizedBox(width: 20),
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          onPressed: f2,
          child: Text('确定'),
        ),
      ),
    ],
  );
}
