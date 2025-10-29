import 'package:mobx/mobx.dart';
import 'package:tutoring_software/modules/status/status.dart';
import 'package:tutoring_software/utils/storage.dart';

part 'status_controller.g.dart';

class StatusController = _StatusController with _$StatusController;

abstract class _StatusController with Store {
  //打开状态盒子
  var statusBox = GStorage.statusBox;

  //登录状态和uID
  @observable
  bool isLogin = false;
  @observable
  String uID = "";

  //初始化，从盒子中获得登录状态和uID
  void init() {
    //status的第一个元素就是登录状态
    var status = statusBox.values.toList()[0];
    isLogin = status.isLogin;
    uID = status.uID;
  }

  //退出登录，也就是直接删除登录状态
  void deleteStatus() {
    statusBox.clear();
    statusBox.add(Status(isLogin: false, uID: ""));
    init();
  }

  //用户登录或者注册，也就是直接修改
  void addStatus(String uID) {
    statusBox.clear();
    statusBox.add(Status(isLogin: true, uID: uID));
    init();
  }
}
