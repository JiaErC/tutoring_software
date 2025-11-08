import 'dart:convert';

import "package:hive/hive.dart";

part 'user_data_item.g.dart';

//定义用户项目的键值
@HiveType(typeId: 1)
class UserDataItem {
  @HiveField(0)
  late String uID;
  @HiveField(1)
  late String uName;
  // @HiveField(2, defaultValue: "../../data/images/1.png")
  // late String uAvatar;
  @HiveField(2, defaultValue: "")
  late String uEmail;
  @HiveField(3, defaultValue: "")
  late String uPhone;
  @HiveField(4, defaultValue: "隐藏")
  late String uGender;
  @HiveField(5, defaultValue: "2000 1 1")
  late String uBirthday;
  // @HiveField(7, defaultValue: "这里什么都没有")
  // late String uSignature;
  // @HiveField(8, defaultValue: "")
  // late String uLocation;
  @HiveField(6, defaultValue: "学生")
  late String uRole;
  @HiveField(7, defaultValue: {})
  late Map<String, dynamic> uTeachSubjects;
  @HiveField(8, defaultValue: {})
  late Map<String, dynamic> uStudySubjects;
  // @HiveField(12,defaultValue: [])
  // late List<String> contacts;
  @HiveField(9)
  late String uPassword;

  //构造函数
  UserDataItem({
    required this.uID,
    required this.uName,
    // required this.uAvatar,
    required this.uEmail,
    required this.uPhone,
    required this.uGender,
    required this.uBirthday,
    required this.uPassword,
    // required this.uSignature,
    // required this.uLocation,
    required this.uRole,
    required this.uTeachSubjects,
    required this.uStudySubjects,
  });

  //通过后端返回的backend来构造数据
  UserDataItem.fromBackend(Map<String, dynamic> u) {
    uID = u['uid'].toString();
    uName = u['username'];
    uPhone = u['phoneNumber'];
    uEmail = u['email'];
    uBirthday = u['birthday'];
    uGender = u['gender'];
    uRole = u['role'];
    uPassword = u['password'];
    try {
      uTeachSubjects =
          u['teachingSubjects'] != null && u['teachingSubjects'].isNotEmpty
          ? jsonDecode(u['teachingSubjects']) as Map<String, dynamic>
          : {};
    } catch (e) {
      print('解析教学科目失败: $e');
      uTeachSubjects = {};
    }
    try {
      uStudySubjects =
          u['learningSubjects'] != null && u['learningSubjects'].isNotEmpty
          ? jsonDecode(u['learningSubjects']) as Map<String, dynamic>
          : {};
    } catch (e) {
      print('解析学习科目失败: $e');
      uStudySubjects = {};
      // uSignature = u['signature'];
      // uLocation = u['location'];
      // contacts = u['contacts'];
    }
  }
  // 添加toString方法以输出详细属性
  @override
  String toString() {
    return 'UserDataItem{\nuID: $uID,\n uName: $uName,\n uEmail: $uEmail,\n uPhone: $uPhone,\n '
        'uGender: $uGender,\n uBirthday: $uBirthday,\n uRole: $uRole,\n '
        'uTeachSubjects: $uTeachSubjects,\n uStudySubjects: $uStudySubjects\n}';
  }
}
