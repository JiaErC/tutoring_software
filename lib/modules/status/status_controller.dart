import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';

import 'package:tutoring_software/modules/status/status.dart';
import 'package:tutoring_software/utils/storage.dart';
import 'package:tutoring_software/modules/user_data/user_data_item.dart';
import 'package:tutoring_software/bean/data_process/json_process.dart';

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
  //生日
  @observable
  String uBirthday = "";
  //性别
  @observable
  String uGender = "";
  //密码
  @observable
  String uPassword = "";

  //判断是否为老师
  @observable
  bool isTeacher = false;

  //初始化，从盒子中获得登录状态和uID
  @action
  void init() {
    //status的第一个元素就是登录状态
    Status status = statusBox.values.toList()[0];
    isLogin = status.isLogin;
    uID = status.uID;
    uName = status.uName;
    uPhone = status.uPhone;
    uEmail = status.uEmail;
    uRole = status.uRole;
    uStudySubjects = status.uStudySubjects;
    uTeachSubjects = status.uTeachSubjects;
    uBirthday = status.uBirthday;
    uGender = status.uGender;
    uPassword = status.uPassword;
  }

  @action
  void changeStatus(Status status) {
    isLogin = status.isLogin;
    uID = status.uID;
    uName = status.uName;
    uPhone = status.uPhone;
    uEmail = status.uEmail;
    uRole = status.uRole;
    uStudySubjects = status.uStudySubjects;
    uTeachSubjects = status.uTeachSubjects;
    uBirthday = status.uBirthday;
    uGender = status.uGender;
    uPassword = status.uPassword;
    debugPrint("status_controller.dart :执行：changeStatus()");
    debugPrint("\n修改了${status.toString()}");
    debugPrint("\n教学科目：${uTeachSubjects.toString()}");
    debugPrint("\n学习科目：${uStudySubjects.toString()}");
    debugPrint("\n changeStatus() 执行完毕\n");
  }

  //退出登录，也就是直接删除登录状态
  @action
  void deleteStatus() {
    statusBox.clear();
    Status newStatus = Status(isLogin: false);
    statusBox.add(newStatus);
    changeStatus(newStatus);
  }

  //用户登录或者注册，也就是直接修改
  @action
  Future<void> setStatus(UserDataItem u) async {
    // 创建新的Status实例，但确保学科数据是深拷贝的
    Status newStatus = Status(
      isLogin: true,
      uID: u.uID,
      uName: u.uName,
      uGender: u.uGender,
      uEmail: u.uEmail,
      uPhone: u.uPhone,
      uRole: u.uRole,
      uBirthday: u.uBirthday,
      uPassword: u.uPassword,
      uTeachSubjects: deepCopyMap(u.uTeachSubjects),
      uStudySubjects: deepCopyMap(u.uStudySubjects),
    );
    statusBox.clear();
    statusBox.add(newStatus);
    changeStatus(newStatus);
    debugPrint(
      "status_controller.dart_状态更新完成: 教学科目=$uTeachSubjects, 学习科目=$uStudySubjects",
    );
  }

  @action
  void updateSubjects(
    Map<String, dynamic> teachSubjects,
    Map<String, dynamic> studySubjects,
  ) {
    // 创建新的Map实例以确保响应式更新
    uTeachSubjects = Map<String, dynamic>.from(teachSubjects);
    uStudySubjects = Map<String, dynamic>.from(studySubjects);

    // 同时更新Hive存储
    if (statusBox.isNotEmpty) {
      Status currentStatus = statusBox.values.first;
      currentStatus.uTeachSubjects = Map<String, dynamic>.from(teachSubjects);
      currentStatus.uStudySubjects = Map<String, dynamic>.from(studySubjects);

      statusBox.clear();
      statusBox.add(currentStatus);

      debugPrint("状态控制器中的学科数据已更新: 教学科目=$uTeachSubjects, 学习科目=$uStudySubjects");
    }
  }

  //改变密码
  // @action
  // void changePassword(String newPassword) {
  //   uPassword = newPassword;
  //   debugPrint('status_controller.dart 控制器中的密码已更新: $uPassword');
  // }
  //修改是否为老师的情况
  @action
  void changeIsTeacher(){
    isTeacher = !isTeacher;
  }
}
