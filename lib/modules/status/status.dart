//记录这个软件的登录情况
import "package:hive/hive.dart";

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
    this.uTeachSubjects =const  {},
    this.uStudySubjects = const {},
  });
}
