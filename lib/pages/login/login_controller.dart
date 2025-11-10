import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

//定义登录控制器
abstract class _LoginController with Store{
  //登录按钮是否可用
  Observable<bool> get loginButtonEnabled;

  //登录按钮点击事件
  void loginButtonClicked();
}