import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:tutoring_software/modules/user_data/user_data_controller.dart';
import 'package:tutoring_software/modules/api/api_settings.dart';

part 'account_controller.g.dart';

class AccountController = _AccountController with _$AccountController;

abstract class _AccountController with Store {
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
  @action
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
          uID = uid;
          return uID;
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

  //存放电话号码
  //通过路由匹配来完成的存储
  @action
  Future<String> savePhoneNumberUid(String phoneNumber, String uid) async {
    try {
      // 将String类型的uid转换为Long类型
      final longUid = int.parse(uid);

      // 正确的实现方式：使用URL查询参数传递参数
      final response = await http
          .post(
            // 使用Uri构造器正确添加查询参数
            Uri.parse('$baseUrl/api/phone-uid/save').replace(
              queryParameters: {
                'phoneNumber': phoneNumber,
                'uid': longUid.toString(),
              },
            ),
            headers: {'Content-Type': 'application/json'},
            // 注意：这里不再需要body参数
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] == 200) {
          debugPrint('电话号码$phoneNumber和UID$uid保存成功');
          return result['data'].toString(); // 返回成功信息
        } else {
          debugPrint('保存失败: ${result['message']}');
          throw Exception('保存失败: ${result['message']}');
        }
      } else {
        debugPrint('API请求失败，状态码：${response.statusCode}，响应体：${response.body}');
        throw Exception('保存电话号码和UID失败: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error saving phone number and UID: $e');
      rethrow;
    }
  }

  //把邮箱存放到后端
  @action
  Future<String> saveEmailUid(String email, String uid) async {
    try {
      // 将String类型的uid转换为Long类型
      final longUid = int.parse(uid);

      // 正确的实现方式：使用URL查询参数传递参数
      final response = await http
          .post(
            // 使用Uri构造器正确添加查询参数
            Uri.parse('$baseUrl/api/email-uid/save').replace(
              queryParameters: {'email': email, 'uid': longUid.toString()},
            ),
            headers: {'Content-Type': 'application/json'},
            // 注意：这里不再需要body参数
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] == 200) {
          debugPrint('邮箱$email和UID$uid保存成功');
          return result['data'].toString(); // 返回成功信息
        } else {
          debugPrint('保存失败: ${result['message']}');
          throw Exception('保存失败: ${result['message']}');
        }
      } else {
        debugPrint('API请求失败，状态码：${response.statusCode}，响应体：${response.body}');
        throw Exception('保存邮箱和UID失败: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error saving email and UID: $e');
      rethrow;
    }
  }

  //在后端通过邮箱查找uID
  @action
  Future<String> getUidByEmail(String email) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/email-uid/by-email/$email'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] == 200) {
          final String uid = result['data']['uid'].toString();
          debugPrint('通过邮箱$email获取到了UID: $uid');
          uID = uid;
          return uID;
        } else {
          throw Exception('通过邮箱$email获取UID失败: ${result['message']}');
        }
      } else {
        debugPrint('API请求失败，状态码：${response.statusCode}，响应体：${response.body}');
        throw Exception(
          'Failed to get UID by email: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  //更新电话号码 - 先删除后保存
  @action
  Future<String> updatePhoneNumberUid(String phoneNumber, String uid) async {
    try {
      // 将String类型的uid转换为Long类型
      final longUid = int.parse(uid);

      // 步骤1: 先根据uid删除现有的电话号码关联
      debugPrint('开始更新电话号码: 先删除UID $uid 现有的电话号码关联');
      final deleteResponse = await http
          .delete(
            Uri.parse('$baseUrl/api/phone-uid/delete/uid/$longUid'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      // 步骤2: 保存新的电话号码和UID关联
      debugPrint('account_controller.dart_删除完成，开始保存新的电话号码 $phoneNumber 和 UID $uid 关联');
      final saveResponse = await http
          .post(
            Uri.parse('$baseUrl/api/phone-uid/save').replace(
              queryParameters: {
                'phoneNumber': phoneNumber,
                'uid': longUid.toString(),
              },
            ),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (saveResponse.statusCode == 200) {
        final result = jsonDecode(saveResponse.body);
        if (result['code'] == 200) {
          debugPrint('电话号码$phoneNumber和UID$uid更新成功（先删除后保存）');
          this.phoneNumber = phoneNumber;
          return result['data'].toString(); // 返回成功信息
        } else {
          debugPrint('account_controller.dart_保存新关联失败: ${result['message']}');
          throw Exception('account_controller.dart_更新失败: ${result['message']}');
        }
      } else {
        debugPrint('account_controller.dart_保存新关联API请求失败，状态码：${saveResponse.statusCode}，响应体：${saveResponse.body}');
        throw Exception('account_controller.dart_更新电话号码和UID失败: HTTP ${saveResponse.statusCode}');
      }
    } catch (e) {
      debugPrint('account_controller.dart_更新电话号码和UID时出错: $e');
      rethrow;
    }
  }

  //更新邮箱 - 先删除后保存
  @action
  Future<String> updateEmailUid(String email, String uid) async {
    try {
      // 将String类型的uid转换为Long类型
      final longUid = int.parse(uid);

      // 步骤1: 先根据uid删除现有的邮箱关联
      debugPrint('account_controller.dart_开始更新邮箱: 先删除UID $uid 现有的邮箱关联');
      final deleteResponse = await http
          .delete(
            Uri.parse('$baseUrl/api/email-uid/delete/uid/$longUid'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      // 步骤2: 保存新的邮箱和UID关联
      debugPrint('account_controller.dart_删除完成，开始保存新的邮箱 $email 和 UID $uid 关联');
      final saveResponse = await http
          .post(
            Uri.parse('$baseUrl/api/email-uid/save').replace(
              queryParameters: {'email': email, 'uid': longUid.toString()},
            ),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (saveResponse.statusCode == 200) {
        final result = jsonDecode(saveResponse.body);
        if (result['code'] == 200) {
          debugPrint('account_controller.dart_邮箱$email和UID$uid更新成功（先删除后保存）');
          this.email = email;
          return result['data'].toString(); // 返回成功信息
        } else {
          debugPrint('account_controller.dart_保存新关联失败: ${result['message']}');
          throw Exception('account_controller.dart_更新失败: ${result['message']}');
        }
      } else {
        debugPrint('account_controller.dart_保存新关联API请求失败，状态码：${saveResponse.statusCode}，响应体：${saveResponse.body}');
        throw Exception('account_controller.dart_更新邮箱和UID失败: HTTP ${saveResponse.statusCode}');
      }
    } catch (e) {
      debugPrint('account_controller.dart_更新邮箱和UID时出错: Error updating email and UID: $e');
      rethrow;
    }
  }

  // //删除账户
  // @action
  // Future<void> deleteUser(String phoneNumber, String email) async {
  //   await userDataController.deleteUserData(uID);
  //   await phoneNumberBox.delete(phoneNumber);
  //   await emailBox.delete(email);
  //   uID = '';
  // }

  //清空控制器的数据
  @action
  void clear() {
    uID = '';
  }
}
