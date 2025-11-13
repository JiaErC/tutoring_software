import "package:hive/hive.dart";
import "package:tutoring_software/modules/user_data/user_data_item.dart";

class GStorage{
  //存储用户相关的数据集
  static late Box<UserDataItem> userDataBox;
  //存储这个用户登录状态的数据集
  static late Box<Status> statusBox;
  //存储手机号和电话号码的数据集
  // static late Box<String> phoneNumberBox;
  // static late Box<String> emailBox;

  //数据库初始化
  static Future init() async {
    Hive.registerAdapter(UserDataItemAdapter());
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
  userID = 'userID',
  userName = 'userName',
  userAvatar = 'userAvatar',
  userEmail = 'userEmail',
  userPhone = 'userPhone',
  userGender = 'userGender',
  userBirthday = 'userBirthday',
  userSignature = 'userSignature',//用户个性签名
  userLocation = 'userLocation',//用户地址
  userCharacter = 'userCharacter',//用户的身份，老师还是学生
  contacts = 'contacts',
  //关于老师的键
  subjectsTaught = 'subjectsTaught',
  //关于学生的键
  subjectsStudied = 'subjectsStudied';
}