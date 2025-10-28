import 'package:flutter/material.dart';

//定义属性类
Widget buildProperty(Widget c){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: c
    );
}