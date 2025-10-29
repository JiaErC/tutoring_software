import "package:hive/hive.dart";

import "package:tutoring_software/modules/user_data/user_data_item.dart";
import 'package:tutoring_software/modules/status/status.dart';

class GStorage {
  //存储用户相关的数据集
  static late Box<UserDataItem> userDataBox;
  //存储这个用户登录状态的数据集
  static late Box<Status> statusBox;

  //数据库初始化
  static Future init() async {
    Hive.registerAdapter(UserDataItemAdapter());
    Hive.registerAdapter(StatusAdapter());
    userDataBox = await Hive.openBox('userData');
    statusBox = await Hive.openBox('status');

    //如果盒子为空，就添加一个默认的登录状态
    if (statusBox.isEmpty) {
      statusBox.add(Status(isLogin: false, uID: ""));
    }
  }
}

class SettingBoxKey {
  static const String
  //有关于用户通用的键
  uID = 'uID', uName = 'uName', uAvatar = 'uAvatar', uEmail = 'uEmail', uPhone = 'uPhone', uGender = 'uGender', uBirthday = 'uBirthday', uSignature = 'uSignature', //用户个性签名
  uLocation = 'uLocation', //用户地址
  uRole = 'uRole', //用户的身份，老师还是学生
  uContacts = 'uContacts',
  //关于老师的键
  uTeachSubjects = 'uTeachSubjects',
  //关于学生的键
  uStudySubjects = 'uStudySubjects';
}
