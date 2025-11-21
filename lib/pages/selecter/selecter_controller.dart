//用来现实筛选的时候需要用到的学科数据等等
import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';

import 'package:tutoring_software/bean/data_process/json_process.dart';

part 'selecter_controller.g.dart';

class SelecterController = _SelecterController with _$SelecterController;

abstract class _SelecterController with Store {
  //用来保存用户的学科
  @observable
  Map<String, dynamic> uStudySubjects = {};
  @observable
  Map<String, dynamic> uTeachSubjects = {};

  //用来保存用户筛选的学科,false为未选择，true为选择
  @observable
  Map<String, bool> selectedStudySubjects = {};
  @observable
  Map<String, bool> selectedTeachSubjects = {};

  //用来保存学科展开情况
  @observable
  Map<String, bool> isViewStudySubjects = {};
  @observable
  Map<String, bool> isViewTeachSubjects = {};

  @observable
  double rating = 0.0;

  //初始化，用来获取用户选择学习或者选择教学的学科
  @action
  init(
    Map<String, dynamic> uStudySubjects,
    Map<String, dynamic> uTeachSubjects,
  ) {
    this.uStudySubjects = deepCopyMap(uStudySubjects);
    this.uTeachSubjects = deepCopyMap(uTeachSubjects);
    debugPrint("selecter_controller:学习学科:$uStudySubjects");
    debugPrint("selecter_controller:教学学科:$uTeachSubjects");
    //对选择情况进行初始化
    selectedStudySubjects = initSubjectsBoolMap(uStudySubjects);
    selectedTeachSubjects = initSubjectsBoolMap(uTeachSubjects);
    debugPrint("selecter_controller:学习学科选择情况:$selectedStudySubjects");
    debugPrint("selecter_controller:教学学科选择情况:$selectedTeachSubjects");
    //对展开情况进行初始化
    isViewStudySubjects = initBigSubjectsBoolMap(uStudySubjects);
    isViewTeachSubjects = initBigSubjectsBoolMap(uTeachSubjects);
    debugPrint("selecter_controller:学习学科展开情况:$isViewStudySubjects");
    debugPrint("selecter_controller:教学学科展开情况:$isViewTeachSubjects");
  }

  //修改大学科的展示情况
  @action
  changeViewStudySubjects(String bigSubject) {
    if (isViewStudySubjects.containsKey(bigSubject)) {
      isViewStudySubjects[bigSubject] = !isViewStudySubjects[bigSubject]!;
    } else {
      isViewStudySubjects[bigSubject] = false;
    }
  }

  //选中了哪些学科
  @action
  changeSelectedStudySubjects(String subject) {
    selectedStudySubjects[subject] = !selectedStudySubjects[subject]!;
  }
}
