// import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/modules/user_data/user_data_controller.dart';

part 'login_controller.g.dart';


class LoginController = _LoginController with _$LoginController;

//定义登录控制器
abstract class _LoginController with Store{
  UserDataController userDataController = Modular.get<UserDataController>();
  @observable
  String account = '';
  @observable
  String password = '';

  //对应的用户数据
  Map<String,dynamic> userData = {};

  // //查询account对应的数据
  // @action
  // Future<UserDataItem?> queryUserData(String account){
  //   return userDataController.findUserByAccount(account);
  // }

}