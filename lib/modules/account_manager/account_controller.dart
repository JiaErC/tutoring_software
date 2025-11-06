import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:tutoring_software/utils/storage.dart';
import 'package:tutoring_software/modules/user_data/user_data_controller.dart';
import 'package:tutoring_software/modules/api/api_settings.dart';

part 'account_controller.g.dart';

class AccountController = _AccountController with _$AccountController;

abstract class _AccountController with Store {
  //打开电话号码和邮箱的盒子
  var phoneNumberBox = GStorage.phoneNumberBox;
  var emailBox = GStorage.emailBox;

  //使用UserDataController
  UserDataController userDataController = Modular.get<UserDataController>();

  @observable
  String uID = '';

  @observable
  String phoneNumber = '';

  @observable
  String email = '';

  @action
  // 获取后端生成的UID
  Future<String> getUid() async {
    try {
      final result = await _generateUid();
      if (result['code'] == 200) {
        // 获取生成的UID
        // final num uidNum = result['data'] as num;
        // final String uidStr = uidNum.toString();
        uID = result['data'].toString();
        debugPrint('获取到了后端生成的UID: $uID');
        // 在这里使用UID
        return uID;
      } else {
        //处理非200响应：抛出带状态码的异常
        throw Exception('UID 生成失败，');
      }
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  //内部生成uID，从后端生成
  Future<Map<String, dynamic>> _generateUid() async {
    /* 根据不同平台选择不同的URL
    String baseUrl;
    if (Platform.isWindows) {
      // Windows环境使用localhost
      baseUrl = 'http://localhost:8080';
    } else if (Platform.isAndroid) {
      // Android环境使用10.0.2.2
      baseUrl = 'http://10.0.2.2:8080';
    } else {
      // 默认使用localhost
      baseUrl = 'http://localhost:8080';
    }*/
    //直接连接到虚拟机IP地址
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/uid/generate'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint('API请求失败，状态码：${response.statusCode}，响应体：${response.body}');
        throw Exception('Failed to generate UID: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('网络请求异常: $e');
      throw Exception('网络连接失败，请检查虚拟机IP和网络设置: $e');
    }
  }

  //通过电话号码访问到UID
  Future<String> getUidByPhone(String phoneNumber) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/phone-uid/by-phone/$phoneNumber'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] == 200) {
          final String uid = result['data']['uid'].toString();
          debugPrint('通过电话号码$phoneNumber获取到了UID: $uid');
          return uid;
        } else {
          throw Exception('通过电话号码获取UID失败: ${result['message']}');
        }
      } else {
        debugPrint('API请求失败，状态码：${response.statusCode}，响应体：${response.body}');
        throw Exception(
          'Failed to get UID by phone: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  //存放电话号码以及uID
  @action
  void putPhoneNumberUID(String phoneNumber, String uID) {
    phoneNumberBox.put(phoneNumber, uID);
  }

  //通过邮箱来存放uID
  @action
  void putEmailUID(String email, String uID) {
    emailBox.put(email, uID);
  }

  //通过电话号码来查找uID
  @action
  Future<void> findPhoneNumberUID(String phoneNumber) async {
    uID = phoneNumberBox.get(phoneNumber) ?? '';
  }

  //通过邮箱来查找uID
  @action
  Future<void> findEmailUID(String email) async {
    uID = emailBox.get(email) ?? '';
  }

  //删除账户
  @action
  Future<void> deleteUser(String phoneNumber, String email) async {
    await userDataController.deleteUserData(uID);
    await phoneNumberBox.delete(phoneNumber);
    await emailBox.delete(email);
    uID = '';
  }

  //清空控制器的数据
  @action
  void clear() {
    uID = '';
  }
}
