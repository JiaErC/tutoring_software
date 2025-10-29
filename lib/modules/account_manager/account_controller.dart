import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';

import 'package:tutoring_software/utils/storage.dart';

part 'account_controller.g.dart';

class AccountController = _AccountController with _$AccountController;

abstract class _AccountController with Store {
  //打开电话号码和邮箱的盒子
  var phoneNumberBox = GStorage.phoneNumberBox;
  var emailBox = GStorage.emailBox;

  @observable
  int phoneNumber = 0;
  @observable
  String email = '';

  //通过电话号码来获取UID
  @computed
  String get uID{
    return phoneNumberBox.get(phoneNumber) ?? '';
  } 

  //存放电话号码以及uID
  void pubPhoneNumberUID(int phoneNumber,String uID){
    phoneNumberBox.put(phoneNumber, PhoneNumberItem());
  }
}
