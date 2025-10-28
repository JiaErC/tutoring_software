import 'package:mobx/mobx.dart';

part 'register_controller.g.dart';

class RegisterController = _RegisterController with _$RegisterController;

abstract class _RegisterController with Store {
  //用户的数据
  @observable
  String uName = '';
  @observable
  String uEmail = '';
  @observable
  String uPhone = '';
  @observable
  String uPassword = '';
  @observable
  int uGender = 0;
  @observable
  String uBirthday = '';
  @observable
  Set<int> uRole = {};
  @observable
  Map<String, dynamic> uTeachSubjects = {};
  @observable
  Map<String, dynamic> uStudySubjects = {};
  //确认密码字段
  @observable
  String uConfirmPassword = '';

  //清空方法，用来清空表单数据
  @action
  void clearAllData() {
    uName = '';
    uEmail = '';
    uPhone = '';
    uPassword = '';
    uConfirmPassword = '';
    uGender = 0;
    uBirthday = '';
    uRole = {};
    uTeachSubjects = {};
    uStudySubjects = {};
  }

  // 更新角色选择
    void toggleRole(int roleId) {
    if (uRole.contains(roleId)) {
      uRole.remove(roleId);
    } else {
      uRole.add(roleId);
    }
  }

    // 检查密码是否一致
  @computed
  bool get isPasswordMatch => uPassword == uConfirmPassword;

}
