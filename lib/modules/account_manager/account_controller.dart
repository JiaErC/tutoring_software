import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/utils/storage.dart';
import 'package:tutoring_software/modules/user_data/user_data_controller.dart';

part 'account_controller.g.dart';

class AccountController = _AccountController with _$AccountController;

abstract class _AccountController with Store {
  //打开电话号码和邮箱的盒子
  var phoneNumberBox = GStorage.phoneNumberBox;
  var emailBox = GStorage.emailBox;

  //使用UserDataController
  UserDataController userDataController =  Modular.get<UserDataController>();

  @observable
  String phoneNumber = '';
  @observable
  String email = '';

  @observable
  String uID = '';

  //存放电话号码以及uID
  @action
  void putPhoneNumberUID(String phoneNumber,String uID){
    phoneNumberBox.put(phoneNumber, uID);
  }

  //通过邮箱来存放uID
  @action
  void putEmailUID(String email,String uID){
    emailBox.put(email, uID);
  }

  //通过电话号码来查找uID
  Future<void> findPhoneNumberUID(String phoneNumber) async{
    uID = phoneNumberBox.get(phoneNumber) ?? '';
  }

  //通过邮箱来查找uID
  Future<void> findEmailUID(String email) async{
    uID = emailBox.get(email) ?? '';
  }

  //删除账户
  @action
  Future<void> deleteUser() async{
    await userDataController.deleteUserData(uID);
    await phoneNumberBox.delete(phoneNumber);
    await emailBox.delete(email);
    uID = '';
    phoneNumber = '';
    email = '';
  }
}
