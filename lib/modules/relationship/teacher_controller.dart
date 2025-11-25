import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tutoring_software/modules/relationship/teacher_info.dart';
import 'package:tutoring_software/modules/api/api_settings.dart';

part 'teacher_controller.g.dart';

class TeacherController = _TeacherController with _$TeacherController;

abstract class _TeacherController with Store {
  //请求URL
  final String TeacherInfoURL = '$baseUrl/api/teacher_info';

  //返回的老师信息列表
  @observable
  List<TeacherInfo> tearchers = [];

  //通过TeacherInfo获取老师们的信息
  @action
  Future<List<TeacherInfo>> searchTeachersInfo(
    Map<String, String> subjects, [
    double minRating = 0.0,
    int minComments = 0,
    int? maxComments = null,
  ]) async {
    // 构建请求体
    final requestBody = {
      'subjects': subjects,
      'minRating': minRating,
      'minComments': minComments,
      if (maxComments != null) 'maxComments': maxComments,
    };

    final response = await http.post(
      Uri.parse('$TeacherInfoURL/search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // 解析响应
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // 检查响应是否成功
      if (responseData['code'] == 200) {
        // 假设200表示成功
        final List<dynamic> teachersData = responseData['data'];
        tearchers = teachersData
            .map((item) => TeacherInfo.fromJson(item))
            .toList();
        //逐个打印teachers
        debugPrint("teacher_controller.dart打印获取的老师信息：");
        for (var teacher in tearchers) {
          debugPrint(teacher.toString());
        }
        return tearchers;
      } else {
        throw Exception('Failed to load teachers: ${responseData['msg']}');
      }
    } else {
      throw Exception('Failed to load teachers: HTTP ${response.statusCode}');
    }
  }

  // 注册教师信息
  @action
  Future<bool> registerTeacher(
    String teacherUid,
    Map<String, String> subjects,
  ) async {
    // 构建请求体
    final requestBody = {'teacherUid': teacherUid, 'subjects': subjects};

    try {
      final response = await http.post(
        Uri.parse('$TeacherInfoURL/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // 解析响应
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // 检查响应是否成功
        if (responseData['code'] == 200) {
          // 假设200表示成功
          debugPrint('Teacher registered successfully: ${responseData['msg']}');
          return true;
        } else {
          debugPrint('Failed to register teacher: ${responseData['msg']}');
          return false;
        }
      } else {
        debugPrint(
          'HTTP error when registering teacher: ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Exception when registering teacher: $e');
      return false;
    }
  }

  //当老师修改自己的科目的时候，更新科目信息
  @action
  Future<bool> updateTeacherCourses(
    String teacherUid,
    Map<String, String> subjects,
  ) async {
    // 构建请求体
    final requestBody = {'teacherUid': teacherUid, 'subjects': subjects};

    try {
      final response = await http.post(
        Uri.parse('$TeacherInfoURL/updateCourses'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // 解析响应
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // 检查响应是否成功
        if (responseData['code'] == 200) {
          // 假设200表示成功
          debugPrint(
            'Teacher courses updated successfully: ${responseData['msg']}',
          );
          return true;
        } else {
          debugPrint(
            'Failed to update teacher courses: ${responseData['msg']}',
          );
          return false;
        }
      } else {
        debugPrint(
          'HTTP error when updating teacher courses: ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Exception when updating teacher courses: $e');
      return false;
    }
  }
}
