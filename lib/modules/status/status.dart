//记录这个软件的登录情况
import "package:hive/hive.dart";

part 'status.g.dart';

//定义用户项目的键值
@HiveType(typeId: 0)
class Status {
  @HiveField(0)
  final bool isLogin;
  @HiveField(1)
  final String uID; //用户登录的ID

  //给isLogin和uID赋值，注册的时候，直接修改
  Status({this.isLogin = false, this.uID = ""});
}
