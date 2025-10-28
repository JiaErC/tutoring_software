import 'package:hive/hive.dart';
import 'package:tutoring_software/modules/user_data/user_data_item.dart';
import 'package:tutoring_software/utils/storage.dart';

class UserDataController {
  // 定义Hive box名称
  static const String userBoxName = 'users';
  // 单例模式
  static final UserDataController _instance = UserDataController._internal();
  factory UserDataController() => _instance;
  UserDataController._internal();

  //打开盒子
  var storedUserDataBox = GStorage.userDataBox;

  // 添加或更新用户数据
  Future<void> saveUserData(UserDataItem userData) async {
    try {
      await storedUserDataBox.put(userData.uID, userData);
      await storedUserDataBox.close();
    } catch (e) {
      print("保存用户数据失败: $e");
      rethrow;
    }
  }

  //根据用户的ID获取用户的数据
  Future<UserDataItem?> getUserData(int uID) async {
    try {
      UserDataItem? userData = storedUserDataBox.get(uID);
      await storedUserDataBox.close();
      return userData;
    } catch (e) {
      print('获取用户数据失败: $e');
      return null;
    }
  }

  // 检查用户是否已存在
  Future<bool> checkUserExists(int uID) async {
    try {
      bool exists = storedUserDataBox.containsKey(uID);
      await storedUserDataBox.close();
      return exists;
    } catch (e) {
      print('检查用户是否存在失败: $e');
      return false;
    }
  }

  // 删除用户数据
  Future<void> deleteUserData(int uID) async {
    try {
      await storedUserDataBox.delete(uID);
      await storedUserDataBox.close();
    } catch (e) {
      print('删除用户数据失败: $e');
      rethrow;
    }
  }

  // 清除所有用户数据
  Future<void> clearAllUsers() async {
    try {
      await storedUserDataBox.clear();
      await storedUserDataBox.close();
    } catch (e) {
      print('清除所有用户数据失败: $e');
      rethrow;
    }
  }

  // 通过邮箱或手机号查找用户
  Future<UserDataItem?> findUserByAccount(String account) async {
    try {
      // 遍历所有用户数据查找匹配的邮箱或手机号
      for (var key in storedUserDataBox.keys) {
        UserDataItem? userData = storedUserDataBox.get(key);
        if (userData != null &&
            (userData.uEmail.toLowerCase() == account.toLowerCase() ||
                userData.uPhone == account)) {
          return userData;
        }
      }
      return null;
    } catch (e) {
      print('通过账号查找用户失败: $e');
      return null;
    }
  }
}
