import "package:hive/hive.dart";

import "package:tutoring_software/modules/user_data/user_data_item.dart";
import 'package:tutoring_software/modules/status/status.dart';

class GStorage {
  //存储用户相关的数据集
  static late Box<UserDataItem> userDataBox;
  //存储这个用户登录状态的数据集
  static late Box<Status> statusBox;
  //存储手机号和电话号码的数据集
  static late Box<String> phoneNumberBox;
  static late Box<String> emailBox;

  //数据库初始化
  static Future init() async {
    Hive.registerAdapter(UserDataItemAdapter());
    Hive.registerAdapter(StatusAdapter());
    /*数据不重要的时候，直接删除数据库解决问题*/
    // await Hive.deleteBoxFromDisk('userData');
    // await Hive.deleteBoxFromDisk('status');
    // await Hive.deleteBoxFromDisk('phoneNumber');
    // await Hive.deleteBoxFromDisk('email');
    userDataBox = await Hive.openBox('userData');
    // userDataBox.clear();
    statusBox = await Hive.openBox('status');
    //如果登录状态盒子为空，就添加一个默认的登录状态
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
