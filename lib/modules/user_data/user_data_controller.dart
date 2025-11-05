import 'package:flutter/material.dart';
import 'package:tutoring_software/modules/user_data/user_data_item.dart';
import 'package:tutoring_software/utils/storage.dart';
import 'package:mobx/mobx.dart';

part 'user_data_controller.g.dart';

class UserDataController = _UserDataController with _$UserDataController;

abstract class _UserDataController with Store {
  //打开盒子
  var storedUserDataBox = GStorage.userDataBox;

  //初始化操作，用来查看UserDataBox中的UserData数据
  void init() {
    var temp = storedUserDataBox.values.toList();
    debugPrint(temp.toString());
  }

  // 添加或更新用户数据
  void saveUserData(UserDataItem userData) async {
    try {
      await storedUserDataBox.put(userData.uID, userData);
    } catch (e) {
      print("保存用户数据失败: $e");
      rethrow;
    }
    debugPrint("保存用户数据成功");
  }

  //根据用户的ID获取用户的数据
  Future<UserDataItem?> getUserData(String uID) async {
    try {
      UserDataItem? userData = storedUserDataBox.get(uID);
      return userData;
    } catch (e) {
      print('获取用户数据失败: $e');
      return null;
    }
  }

  // 检查用户是否已存在
  Future<bool> checkUserExists(String uID) async {
    try {
      bool exists = storedUserDataBox.containsKey(uID);
      return exists;
    } catch (e) {
      print('检查用户是否存在失败: $e');
      return false;
    }
  }

  // 删除用户数据
  Future<void> deleteUserData(String uID) async {
    try {
      await storedUserDataBox.delete(uID);
    } catch (e) {
      print('删除用户数据失败: $e');
      rethrow;
    }
  }

  // 清除所有用户数据
  Future<void> clearAllUsers() async {
    try {
      await storedUserDataBox.clear();
    } catch (e) {
      print('清除所有用户数据失败: $e');
      rethrow;
    }
  }
}
