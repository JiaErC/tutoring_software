import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';

import 'package:tutoring_software/modules/status/status.dart';
import 'package:tutoring_software/utils/storage.dart';
import 'package:tutoring_software/modules/user_data/user_data_item.dart';

part 'status_controller.g.dart';

class StatusController = _StatusController with _$StatusController;

abstract class _StatusController with Store {
  //打开状态盒子
  var statusBox = GStorage.statusBox;

  //登录状态和uID
  @observable
  bool isLogin = false;
  @observable
  String uID = "";
  //用户名
  @observable
  String uName = "";
  //联系方式
  @observable
  String uPhone = "";
  @observable 
  String uEmail = "";
  @observable
  String uRole = "";
  //学习的科目和教学的科目
  @observable
  Map<String, dynamic> uStudySubjects = {};
  @observable
  Map<String, dynamic> uTeachSubjects = {};
  

  //初始化，从盒子中获得登录状态和uID
  void init() {
    //status的第一个元素就是登录状态
    var status = statusBox.values.toList()[0];
    isLogin = status.isLogin;
    uID = status.uID;
    uName = status.uName;
    uPhone = status.uPhone;
    uEmail = status.uEmail;
    uRole = status.uRole;
    uStudySubjects = status.uStudySubjects;
    uTeachSubjects = status.uTeachSubjects;
    debugPrint("\n\n\n${status.toString()}");
  }

  //退出登录，也就是直接删除登录状态
  void deleteStatus() {
    statusBox.clear();
    statusBox.add(Status(isLogin: false));
    init();
  }

  //用户登录或者注册，也就是直接修改
  void setStatus(UserDataItem u) {
    statusBox.clear();
    statusBox.add(Status.fromUserDataItem(u));
    init();
  }
}
