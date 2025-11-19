import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tutoring_software/modules/user_data/user_data_item.dart';
import 'package:tutoring_software/modules/api/api_settings.dart';
import 'package:tutoring_software/bean/data_process/json_process.dart';

part 'search_controller.g.dart';

class SearchController = _SearchController with _$SearchController;

abstract class _SearchController with Store {
  //这是搜索到的用户的uID和信息
  @observable
  String searchUid = '';
  @observable
  late UserDataItem searchUserData;
  //用户教学学科的选择map
  @observable
  Map<String, bool> selectedTeachSubjectsMap = {};
  @observable
  Map<String, bool> isViewSubjects = {};

  //对用户的评分
  @observable
  double userRating = 0.0;

  //通过Uid获取用户信息
  @action
  Future<void> searchUserDataItem(String uid) async {
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
          debugPrint('search_controller.dart 获取用户数据成功: ${result['message']}');
          searchUserData = UserDataItem.fromBackend(result['data']);
          debugPrint(
            'search_controller.dart 用户的选课情况: ${searchUserData.uTeachSubjects}',
          );
          selectedTeachSubjectsMap = initSubjectsBoolMap(
            searchUserData.uTeachSubjects,
          );
          isViewSubjects = searchUserData.uTeachSubjects.map(
            (key, value) => MapEntry(key, true),
          );
          searchUid = uid;
        } else {
          debugPrint('search_controller.dart 获取用户数据失败: ${result['message']}');
          throw Exception('获取失败:${result['message']}');
        }
      } else {
        debugPrint(
          'search_controller.dart API请求失败，状态码：${response.statusCode}，响应体：${response.body}',
        );
        throw Exception(
          'search_controller.dart 获取用户数据失败: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  //通过电话号码获取Uid
  @action
  Future<void> searchUidByPhone(String phoneNumber) async {
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
          debugPrint('search_controller.dart 通过电话号码$phoneNumber获取到了UID: $uid');
          searchUserDataItem(uid);
        } else {
          throw Exception(
            'search_controller.dart 通过电话号码获取UID失败: ${result['message']}',
          );
        }
      } else {
        debugPrint(
          'search_controller.dart API请求失败，状态码：${response.statusCode}，响应体：${response.body}',
        );
        throw Exception(
          'search_controller.dart Failed to get UID by phone: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('search_controller.dart Error: $e');
      rethrow;
    }
  }

  //通过Email搜索Uid
  Future<void> searchUidByEmail(String email) async {
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
          debugPrint('search_controller.dart 通过邮箱$email获取到了UID: $uid');
          searchUserDataItem(uid);
        } else {
          throw Exception(
            'search_controller.dart 通过邮箱$email获取UID失败: ${result['message']}',
          );
        }
      } else {
        debugPrint(
          'search_controller.dart API请求失败，状态码：${response.statusCode}，响应体：${response.body}',
        );
        throw Exception(
          'search_controller.dart Failed to get UID by email: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('search_controller.dart Error: $e');
      rethrow;
    }
  }

  //修改显示学科
  @action
  void switchViewSubjects(String bigSubject) {
    isViewSubjects[bigSubject] = !(isViewSubjects[bigSubject] ?? false);
      // 打印调试信息
  debugPrint("search_controller.dart $bigSubject是否展开：${isViewSubjects[bigSubject]}");
  }

  //修改选择的学科
  @action
  void changeSelectedSubjects(String s) {
    // 设置当前点击的学科为选中状态
    if (selectedTeachSubjectsMap.containsKey(s)) {
      // 清除所有学科的选中状态
      selectedTeachSubjectsMap = selectedTeachSubjectsMap.map((key, value) {
        return MapEntry(key, key == s ? !value : false); // 只有 s 的值取反，其他都为 false
      });
    } else {
      // 清除所有学科的选中状态
      selectedTeachSubjectsMap = selectedTeachSubjectsMap.map((key, value) {
        return MapEntry(key, false);
      });
      selectedTeachSubjectsMap[s] = true;
    }
    debugPrint("search_controller.dart 学科状态: $selectedTeachSubjectsMap");
  }
}
