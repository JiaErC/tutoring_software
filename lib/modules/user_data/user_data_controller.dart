import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;

import 'package:tutoring_software/modules/user_data/user_data_item.dart';
import 'package:tutoring_software/utils/storage.dart';
import 'package:tutoring_software/modules/api/api_settings.dart';

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

  //存放用户信息
  @action
  Future<String> saveUserData(UserDataItem u) async {
    // debugPrint('保存用户学科数据 - 教学: ${u.uTeachSubjects}');
    // debugPrint('保存用户学科数据 - 学习: ${u.uStudySubjects}');
    //打印经过jsonEncode之后的数据
    String teachSubjects = jsonEncode(u.uTeachSubjects);
    String studySubjects = jsonEncode(u.uStudySubjects);
    // debugPrint('保存用户学科数据 - 教学 JSON: $teachSubjects');
    // debugPrint('保存用户学科数据 - 学习 JSON: $studySubjects');
    try {
      // 将String类型的uid转换为Long类型
      final longUid = int.parse(u.uID);

      //把数据放到盒子中
      await storedUserDataBox.put(u.uID, u);

      // 构建请求体数据，确保字段名称与后端匹配
      final requestBody = {
        'uid': longUid,
        'username': u.uName,
        'phoneNumber': u.uPhone,
        'email': u.uEmail,
        'birthday': u.uBirthday,
        'role': u.uRole,
        'gender': u.uGender,
        'password': u.uPassword,
        // 将Map类型转换为JSON字符串
        // 修改字段名为后端期望的名称，并添加额外的非空检查
        'teachSubjects': teachSubjects,
        'studySubjects': studySubjects
      };
      //检查是否在构建时期产生了错误
      debugPrint(
        "请求的学科，教学的学科，学习学科：$teachSubjects $studySubjects\n\n",
      );

      //通过URI来传递信息
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/user-data-item/save'),
            headers: {'Content-Type': 'application/json'},
            // 发送JSON格式的请求体
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 10));
      // 处理响应
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] == 200) {
          debugPrint('保存用户数据成功: ${result['message']}');
          return result['data'].toString();
        } else {
          debugPrint('保存用户数据失败: ${result['message']}');
          throw Exception('保存失败:${result['message']}');
        }
      } else {
        debugPrint('API请求失败，状态码：${response.statusCode}，响应体：${response.body}');
        throw Exception('保存用户数据失败: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  //根据用户的ID获取用户的数据
  // Future<UserDataItem?> getUserData(String uID) async {
  //   try {
  //     UserDataItem? userData = storedUserDataBox.get(uID);
  //     return userData;
  //   } catch (e) {
  //     print('获取用户数据失败: $e');
  //     return null;
  //   }
  // }

  Future<UserDataItem?> getUserData(String uid) async {
    //打印uID
    debugPrint('获取用户数据: $uid');

    try {
      // 添加UID类型验证和转换逻辑
      if (uid.isEmpty) {
        throw Exception('UID不能为空');
      }
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/user-data-item/get/$uid'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] == 200) {
          debugPrint('获取用户数据成功: ${result['message']}');
          return UserDataItem.fromBackend(result['data']);
        } else {
          debugPrint('获取用户数据失败: ${result['message']}');
          throw Exception('获取失败:${result['message']}');
        }
      } else {
        debugPrint('API请求失败，状态码：${response.statusCode}，响应体：${response.body}');
        throw Exception('获取用户数据失败: HTTP ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
    //     try {
    //   final response = await http
    //       .get(
    //         Uri.parse('$baseUrl/api/email-uid/by-email/$email'),
    //         headers: {'Content-Type': 'application/json'},
    //       )
    //       .timeout(const Duration(seconds: 10));

    //   if (response.statusCode == 200) {
    //     final result = jsonDecode(response.body);
    //     if (result['code'] == 200) {
    //       final String uid = result['data']['uid'].toString();
    //       debugPrint('通过邮箱$email获取到了UID: $uid');
    //       return uid;
    //     } else {
    //       throw Exception('通过邮箱$email获取UID失败: ${result['message']}');
    //     }
    //   } else {
    //     debugPrint('API请求失败，状态码：${response.statusCode}，响应体：${response.body}');
    //     throw Exception(
    //       'Failed to get UID by email: HTTP ${response.statusCode}',
    //     );
    //   }
    // } catch (e) {
    //   debugPrint('Error: $e');
    //   rethrow;
    // }
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
