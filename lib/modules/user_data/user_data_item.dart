import "package:hive/hive.dart";

part 'user_data_item.g.dart';

//定义用户项目的键值
@HiveType(typeId:0)
class UserDataItem {
  @HiveField(0)
  late int userID;
  @HiveField(1)
  late String userName;
  @HiveField(2, defaultValue: "../../data/images/1.png")
  late String userAvatar;
  @HiveField(3, defaultValue: "")
  late String userEmail;
  @HiveField(4, defaultValue: "")
  late String userPhone;
  @HiveField(5, defaultValue: "隐藏")
  late String userGender;
  @HiveField(6, defaultValue: "2000 1 1")
  late String userBirthday;
  @HiveField(7, defaultValue: "这里什么都没有")
  late String userSignature;
  @HiveField(8, defaultValue: "")
  late String userLocation;
  @HiveField(9, defaultValue: "学生")
  late String userCharacter;
  @HiveField(10, defaultValue: [])
  late List<Map<String, dynamic>> subjectsTaught;
  @HiveField(11,defaultValue: [])
  late List<Map<String, dynamic>> subjectsStudied;
  @HiveField(12,defaultValue: [])
  late List<String> contacts;

  //构造函数
  UserDataItem({
    required this.userID,
    required this.userName,
    required this.userAvatar,
    required this.userEmail,
    required this.userPhone,
    required this.userGender,
    required this.userBirthday,
    required this.userSignature,
    required this.userLocation,
    required this.userCharacter,
    required this.subjectsTaught,
    required this.subjectsStudied,
  });
}