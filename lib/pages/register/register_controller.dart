import 'package:mobx/mobx.dart';

part 'register_controller.g.dart';

class RegisterController = _RegisterController with _$RegisterController;

abstract class _RegisterController with Store{
  //用户的数据
  @observable
  String username = '';
  @observable
  String email = '';
  @observable
  String password = '';
  @observable
  String phone = '';
  @observable
  int gender = 0;
  @observable
  String birthday = '';
  @observable
  Set<int> role = {};
  @observable
  Map<String, dynamic> studySubjects = {};
  @observable
  Map<String, dynamic> teachSubjects = {};

  //验证用户输入的邮箱是否正确

  //获取用户输入的数据是否正确的方法

  //清空方法，用来清空表单数据

}