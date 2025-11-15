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
  @observable
  Map<String, bool> isViewSubjects = {};

  //获取状态控制器
  final statusController = Modular.get<StatusController>();

  @action
  void init() {
    isLogin = statusController.isLogin;
    if (isLogin) {
      isStudent = statusController.uRole.contains("1") ? true : false;
      // 使用runInAction确保所有observable变量在同一action中更新
      runInAction(() {
        subjects = isStudent
            ? statusController.uStudySubjects
            : statusController.uTeachSubjects;
        isViewSubjects = subjects.map((key, value) => MapEntry(key, true));
        debugPrint("\n用户角色: $isStudent");
        debugPrint("学习科目: ${statusController.uStudySubjects}");
        debugPrint("教学科目: ${statusController.uTeachSubjects}");
        debugPrint("当前subjects: $subjects");
        debugPrint("isViewSubjects是$isViewSubjects\n");
      });
    } else {
      runInAction(() {
        subjects = {};
        isViewSubjects = {};
      });
    }
  }

  @action
  void switchIdentity() {
    isStudent = !isStudent;
    subjects = isStudent
        ? statusController.uStudySubjects
        : statusController.uTeachSubjects;
    isViewSubjects = subjects.map((key, value) => MapEntry(key, true));
    debugPrint("\nisViewSubjects是$isViewSubjects\n");
  }

  @action
  void switchViewSubjects(String s) {
    // 添加空值检查，避免对null使用!操作符
    if (isViewSubjects.containsKey(s)) {
      isViewSubjects[s] = !isViewSubjects[s]!;
    }
  }
}
