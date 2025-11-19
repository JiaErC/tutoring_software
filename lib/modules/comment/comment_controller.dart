import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;

import 'package:tutoring_software/modules/api/api_settings.dart';
import 'package:tutoring_software/modules/comment/comment.dart';

part 'comment_controller.g.dart';

class CommentController = _CommentController with _$CommentController;

abstract class _CommentController with Store {
  //后端传输URL
  final String commentUrl = "$baseUrl/api/comment";

  //当用户的身份是学生或者老师的时候获取到的评论
  @observable
  List<Comment> studentList = [];
  @observable
  List<Comment> teacherList = [];

  // 根据学生UID获取评论列表
  @action
  Future<void> getCommentsByStudentUid(String studentUid) async {
    try {
      debugPrint('comment_controller.dart_获取学生$studentUid的评论列表');

      final response = await http.get(
        Uri.parse('$commentUrl/student/$studentUid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['code'] == 200 && result['data'] != null) {
          // 将JSON数组转换为Comment对象列表
          List<dynamic> commentsJson = result['data'];
          List<Comment> comments = commentsJson
              .map((json) => Comment.fromJson(json))
              .toList();

          studentList = comments;
          debugPrint(
            'comment_controller.dart_成功获取学生评论列表，数量：${comments.length}',
          );
        } else {
          debugPrint(
            'comment_controller.dart_获取评论失败: ${result['message'] ?? '未知错误'}',
          );
        }
      } else {
        debugPrint('comment_controller.dart_服务器错误: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('comment_controller.dart_网络错误: $e');
    }
  }

  // 根据老师UID获取评论列表
  @action
  Future<void> getCommentsByTeacherUid(String teacherUid) async {
    try {
      debugPrint('comment_controller.dart_获取老师$teacherUid的评论列表');
      final response = await http.get(
        Uri.parse('$commentUrl/teacher/$teacherUid'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['code'] == 200 && result['data'] != null) {
          // 将JSON数组转换为Comment对象列表
          List<dynamic> commentsJson = result['data'];
          List<Comment> comments = commentsJson
              .map((json) => Comment.fromJson(json))
              .toList();
          teacherList = comments;
          debugPrint(
            'comment_controller.dart_成功获取老师评论列表，数量：${comments.length}',
          );
        } else {
          debugPrint(
            'comment_controller.dart_获取评论失败: ${result['message'] ?? '未知错误'}',
          );
        }
      } else {
        debugPrint('comment_controller.dart_服务器错误: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('comment_controller.dart_网络错误: $e');
    }
  }

  // 保存评论的方法（可选实现）
  @action
  Future<bool> saveComment(Comment comment) async {
    // 添加调试日志，打印请求URL和请求体
    debugPrint('comment_controller.dart_保存评论请求URL: $commentUrl/save');
    debugPrint('comment_controller.dart_请求体: ${json.encode(comment.toJson())}');

    try {
      final response = await http
          .post(
            Uri.parse('$commentUrl/save'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(comment.toJson()),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['code'] == 200) {
          debugPrint('comment_controller.dart_保存评论成功');
          return true;
        } else {
          debugPrint(
            'comment_controller.dart_保存评论失败: ${result['message'] ?? '未知错误'}',
          );
          return false;
        }
      } else {
        debugPrint('comment_controller.dart_服务器错误: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('comment_controller.dart_网络错误: $e');
      return false;
    }
  }
}
