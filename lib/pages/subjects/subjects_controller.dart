import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/modules/status/status_controller.dart';
import 'package:tutoring_software/bean/data_process/json_process.dart';

part 'subjects_controller.g.dart';

class SubjectsController = _SubjectsController with _$SubjectsController;

abstract class _SubjectsController with Store {
  //引入状态控制器
  final StatusController statusController = Modular.get<StatusController>();

  @observable
  Map<String, dynamic> studySubjects = {};
  @observable
  Map<String, dynamic> teachSubjects = {};
  @observable
  int teachSubjectsCount = 0;
  @observable
  int studySubjectsCount = 0;

  //初始化方法，当StatusController.isLogin为true的时候调用
  @action
  void init() {
    if (statusController.isLogin) {
      if (statusController.isLogin) {
        // 从StatusController获取教学科目信息
        if (statusController.uTeachSubjects.isNotEmpty) {
          teachSubjects = deepCopyMap(statusController.uTeachSubjects);
          calculateTeachSubjectsCount();
        }
        // 从StatusController获取学习科目信息
        if (statusController.uStudySubjects.isNotEmpty) {
          studySubjects = deepCopyMap(statusController.uStudySubjects);
          calculateStudySubjectsCount();
        }
        debugPrint('subjects_controller.dart 初始化信息：\n$teachSubjects\n$studySubjects');
      }
    }
  }

  //注册的时候做出的调整，当退出注册页面的时候需要调用init()
  @action
  void registerInit(){
    teachSubjects.clear();
    studySubjects.clear();
    teachSubjectsCount = 0;
    studySubjectsCount = 0;
    debugPrint('subjects_controller.dart 注册页面初始化信息');
  }

  @action
  void updateTeachSubjects(Map<String, dynamic> subjects) {
    teachSubjects = Map.from(subjects);
    calculateTeachSubjectsCount();
  }

  @action
  void updateStudySubjects(Map<String, dynamic> subjects) {
    studySubjects = Map.from(subjects);
    calculateStudySubjectsCount();
  }

  @action
  void calculateTeachSubjectsCount() {
    int count = 0;
    teachSubjects.forEach((category, subcategories) {
      if (subcategories is Map) {
        subcategories.forEach((subcategory, subjects) {
          if (subjects is List) {
            count += subjects.length;
          }
        });
      }
    });
    teachSubjectsCount = count;
  }

  @action
  void calculateStudySubjectsCount() {
    int count = 0;
    studySubjects.forEach((category, subcategories) {
      if (subcategories is Map) {
        subcategories.forEach((subcategory, subjects) {
          if (subjects is List) {
            count += subjects.length;
          }
        });
      }
    });
    studySubjectsCount = count;
  }

  @action
  void clearAllSubjects() {
    teachSubjects.clear();
    studySubjects.clear();
    teachSubjectsCount = 0;
    studySubjectsCount = 0;
  }
}
