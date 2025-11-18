//记录这个软件的登录情况
import "package:hive/hive.dart";

import 'package:tutoring_software/modules/user_data/user_data_item.dart';
import 'package:tutoring_software/bean/data_process/json_process.dart';

part 'status.g.dart';

//定义用户项目的键值
@HiveType(typeId: 0)
class Status {
  @HiveField(0)
  late bool isLogin;
  @HiveField(1)
  late String uID; //用户登录的ID
  @HiveField(2)
  late String uName;
  @HiveField(3)
  late String uGender;
  @HiveField(4)
  late String uEmail;
  @HiveField(5)
  late String uPhone;
  @HiveField(6)
  late String uRole;
  @HiveField(7)
  late String uBirthday;
  @HiveField(8)
  late Map<String, dynamic> uTeachSubjects;
  @HiveField(9)
  late Map<String, dynamic> uStudySubjects;
  @HiveField(10)
  late String uPassword;

  //给isLogin和uID赋值，注册的时候，直接修改
  Status({
    this.isLogin = false,
    this.uID = "",
    this.uName = "",
    this.uGender = "",
    this.uEmail = "",
    this.uPhone = "",
    this.uRole = "",
    this.uBirthday = "",
    this.uTeachSubjects = const {},
    this.uStudySubjects = const {},
    this.uPassword = "",
  });

  //从UserDataItem中的命名构造函数
  Status.fromUserDataItem(UserDataItem item) {
    isLogin = true;
    uID = item.uID;
    uName = item.uName;
    uGender = item.uGender;
    uEmail = item.uEmail;
    uPhone = item.uPhone;
    uRole = item.uRole;
    uBirthday = item.uBirthday;
    uPassword = item.uPassword;
    // 关键修复：创建深拷贝而不是直接引用
    uTeachSubjects = deepCopyMap(item.uTeachSubjects);
    uStudySubjects = deepCopyMap(item.uStudySubjects);
  }


  //toString方法
  @override
  String toString() {
    return "isLogin: $isLogin, uID: $uID, uName: $uName, uGender: $uGender, uEmail: $uEmail, uPhone: $uPhone, uRole: $uRole, uBirthday: $uBirthday, uTeachSubjects: $uTeachSubjects, uStudySubjects: $uStudySubjects";
  }
}
