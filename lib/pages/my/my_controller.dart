import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/modules/status/status_controller.dart';

part 'my_controller.g.dart';

class MyController = _MyController with _$MyController;

abstract class _MyController with Store {
  @observable
  bool isLogin = false;
  //检查是否是老师
  @observable
  bool isStudent = true;
  //老师或者学生学习的科目
  @observable
  Map<String, dynamic> subjects = {};

  //获取状态控制器
  final statusController = Modular.get<StatusController>();

  @action
  void init() {
    isLogin = statusController.isLogin;
    if (isLogin) {
      isStudent = statusController.uRole.contains("1") ? true : false;
      subjects = isStudent
          ? statusController.uStudySubjects
          : statusController.uTeachSubjects;
    }
  }

  @action
  void switchIdentity() {
    isStudent = !isStudent;
    subjects = isStudent
        ? statusController.uStudySubjects
        : statusController.uTeachSubjects;
  }
}
