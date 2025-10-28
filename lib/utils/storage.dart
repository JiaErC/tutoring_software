import "package:hive/hive.dart";
import "package:tutoring_software/modules/user_data/user_data_item.dart";

class GStorage{
  //存储用户相关的数据集
  static late Box<UserDataItem> userDataBox;

  //数据库初始化
  static Future init() async {
    Hive.registerAdapter(UserDataItemAdapter());
    userDataBox = await Hive.openBox('userData');
  }

}
class SettingBoxKey {
  static const String 
  //有关于用户通用的键
  uID = 'uID',
  uName = 'uName',
  uAvatar = 'uAvatar',
  uEmail = 'uEmail',
  uPhone = 'uPhone',
  uGender = 'uGender',
  uBirthday = 'uBirthday',
  uSignature = 'uSignature',//用户个性签名
  uLocation = 'uLocation',//用户地址
  uRole = 'uRole',//用户的身份，老师还是学生
  uContacts = 'uContacts',
  //关于老师的键
  uTeachSubjects = 'uTeachSubjects',
  //关于学生的键
  uStudySubjects = 'uStudySubjects';
}