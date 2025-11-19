import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;

import 'package:tutoring_software/modules/api/api_settings.dart';
import 'package:tutoring_software/modules/relationship/ts_relationship.dart';

part 'relationship_controller.g.dart';

class RelationshipController = _RelationshipController with _$RelationshipController;

abstract class _RelationshipController with Store {
  // 后端传输URL
  final String relationshipUrl = "$baseUrl/api/ts-relationship";

  // 存储师生关系列表
  @observable
  List<TSRelationship> studentRelationships = [];
  @observable
  List<TSRelationship> teacherRelationships = [];
  @observable
  TSRelationship? currentRelationship;

  // 根据学生UID获取师生关系列表
  @action
  Future<void> getRelationshipsByStudentUid(String studentUid) async {
    try {
      debugPrint('relationship_controller.dart_获取学生$studentUid的师生关系列表');

      final response = await http.get(
        Uri.parse('$relationshipUrl/student/$studentUid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['code'] == 200 && result['data'] != null) {
          // 将JSON数组转换为TSRelationship对象列表
          List<dynamic> relationshipsJson = result['data'];
          List<TSRelationship> relationships = relationshipsJson
              .map((json) => TSRelationship.fromJson(json))
              .toList();

          studentRelationships = relationships;
          debugPrint(
            'relationship_controller.dart_成功获取学生关系列表，数量：${relationships.length}',
          );
        } else {
          debugPrint(
            'relationship_controller.dart_获取关系失败: ${result['message'] ?? '未知错误'}',
          );
        }
      } else {
        debugPrint('relationship_controller.dart_服务器错误: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('relationship_controller.dart_网络错误: $e');
    }
  }

  // 根据老师UID获取师生关系列表
  @action
  Future<void> getRelationshipsByTeacherUid(String teacherUid) async {
    try {
      debugPrint('relationship_controller.dart_获取老师$teacherUid的师生关系列表');
      final response = await http.get(
        Uri.parse('$relationshipUrl/teacher/$teacherUid'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['code'] == 200 && result['data'] != null) {
          // 将JSON数组转换为TSRelationship对象列表
          List<dynamic> relationshipsJson = result['data'];
          List<TSRelationship> relationships = relationshipsJson
              .map((json) => TSRelationship.fromJson(json))
              .toList();
          teacherRelationships = relationships;
          debugPrint(
            'relationship_controller.dart_成功获取老师关系列表，数量：${relationships.length}',
          );
        } else {
          debugPrint(
            'relationship_controller.dart_获取关系失败: ${result['message'] ?? '未知错误'}',
          );
        }
      } else {
        debugPrint('relationship_controller.dart_服务器错误: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('relationship_controller.dart_网络错误: $e');
    }
  }

  // 检查特定的师生关系
  @action
  Future<bool> checkRelationship(String studentUid, String teacherUid) async {
    try {
      debugPrint('relationship_controller.dart_检查学生$studentUid和老师$teacherUid的关系');
      final response = await http.get(
        Uri.parse('$relationshipUrl/check?studentUid=$studentUid&teacherUid=$teacherUid'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['code'] == 200 && result['data'] != null) {
          // 解析关系数据
          currentRelationship = TSRelationship.fromJson(result['data']);
          debugPrint('relationship_controller.dart_关系检查成功，关系存在');
          return true;
        } else {
          debugPrint('relationship_controller.dart_关系不存在');
          currentRelationship = null;
          return false;
        }
      } else {
        debugPrint('relationship_controller.dart_服务器错误: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('relationship_controller.dart_网络错误: $e');
      return false;
    }
  }

  // 保存师生关系
  @action
  Future<bool> saveRelationship(TSRelationship relationship) async {
    try {
      debugPrint('relationship_controller.dart_保存师生关系: 学生${relationship.studentUid} 和老师${relationship.teacherUid}');
      
      final response = await http
          .post(
            Uri.parse('$relationshipUrl/save'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(relationship.toJson()),
          )
          .timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['code'] == 200) {
          debugPrint('relationship_controller.dart_保存师生关系成功');
          return true;
        } else {
          debugPrint(
            'relationship_controller.dart_保存师生关系失败: ${result['message'] ?? '未知错误'}',
          );
          return false;
        }
      } else {
        debugPrint('relationship_controller.dart_服务器错误: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('relationship_controller.dart_网络错误: $e');
      return false;
    }
  }

  // 删除师生关系
  @action
  Future<bool> deleteRelationship(String studentUid, String teacherUid) async {
    try {
      debugPrint('relationship_controller.dart_删除师生关系: 学生$studentUid 和老师$teacherUid');
      
      final response = await http
          .delete(
            Uri.parse('$relationshipUrl/delete?studentUid=$studentUid&teacherUid=$teacherUid'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['code'] == 200) {
          debugPrint('relationship_controller.dart_删除师生关系成功');
          return true;
        } else {
          debugPrint(
            'relationship_controller.dart_删除师生关系失败: ${result['message'] ?? '未知错误'}',
          );
          return false;
        }
      } else {
        debugPrint('relationship_controller.dart_服务器错误: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('relationship_controller.dart_网络错误: $e');
      return false;
    }
  }
}