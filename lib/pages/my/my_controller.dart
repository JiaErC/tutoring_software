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
  @observable
  bool isView = false;
  //查看评论
  @observable
  bool isViewComment = false;

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
        debugPrint("以下为my_controller.dart的init信息：");
        debugPrint("\n用户角色: $isStudent");
        debugPrint("学习科目: ${statusController.uStudySubjects}");
        debugPrint("教学科目: ${statusController.uTeachSubjects}");
        debugPrint("当前init获取的subjects: $subjects");
        debugPrint("isViewSubjects是$isViewSubjects\n");
        debugPrint("my_controller.dart的init结束\n");
      });
    } else {
      runInAction(() {
        subjects = {};
        isViewSubjects = {};
      });
    }
  }

  //获取学科
  @action
  void getSubjects() {
    debugPrint(
      "my_controller.dart_fuck 获取到的学科信息:${statusController.uStudySubjects}\n${statusController.uTeachSubjects}\n",
    );
      // 创建新的Map实例，确保MobX能检测到变化
  final Map<String, dynamic> newSubjects = Map.from(
    isStudent
        ? statusController.uStudySubjects
        : statusController.uTeachSubjects
  );
    // 使用runInAction确保observable变量更新能被MobX正确跟踪
    runInAction(() {
      subjects = newSubjects;
      isViewSubjects = subjects.map((key, value) => MapEntry(key, true));
      debugPrint("以下为my_controller.dart的getSubjects信息：\n");
      debugPrint("fuck 获取到的学科：$subjects");
      debugPrint("fuck 获取到的isViewSubjects：$isViewSubjects\n");
      debugPrint("getSubjects结束\n");
    });
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

  @action
  void switchView() {
    isView = !isView;
  }

  @action
  void switchCommentsView() {
    isViewComment = !isViewComment;
  }
}
