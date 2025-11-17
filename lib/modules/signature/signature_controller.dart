import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tutoring_software/modules/api/api_settings.dart';

part 'signature_controller.g.dart';

class SignatureController = _SignatureController with _$SignatureController;

abstract class _SignatureController with Store {
  // API 基础路径
  final String signatureBaseUrl = '$baseUrl/api/user-signatures';

  // 存储签名
  @action
  Future<bool> saveSignature(String uid, String signature) async {
    try {
      final response = await http.post(
        Uri.parse('$signatureBaseUrl/save'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'uid': uid, 'signatures': signature}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] == 200) {
          debugPrint('签名保存成功: $signature');
          return true;
        } else {
          debugPrint('签名保存失败: ${result['message']}');
          return false;
        }
      } else {
        debugPrint('签名保存失败，状态码: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('保存签名时发生错误: $e');
      return false;
    }
  }

  // 更新签名
  @action
  Future<bool> updateSignature(String uid, String signature) async {
    try {
      final response = await http.put(
        Uri.parse('$signatureBaseUrl/update'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'uid': uid, 'signatures': signature}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] == 200) {
          debugPrint('签名更新成功: $signature');
          return true;
        } else {
          debugPrint('签名更新失败: ${result['message']}');
          return false;
        }
      } else {
        debugPrint('签名更新失败，状态码: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('更新签名时发生错误: $e');
      return false;
    }
  }

  // 获取签名
  @action
  Future<String?> getSignature(String uid) async {
    try {
      final response = await http.get(
        Uri.parse('$signatureBaseUrl/get/$uid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] == 200) {
          final signature = result['data']['signatures'];
          debugPrint('获取到的签名: $signature');
          return signature;
        } else {
          debugPrint('获取签名失败: ${result['message']}');
          return null;
        }
      } else {
        debugPrint('获取签名失败，状态码: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('获取签名时发生错误: $e');
      return null;
    }
  }

  // 删除签名
  @action
  Future<bool> deleteSignature(String uid) async {
    try {
      final response = await http.delete(
        Uri.parse('$signatureBaseUrl/delete/$uid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] == 200) {
          debugPrint('签名删除成功');
          return true;
        } else {
          debugPrint('签名删除失败: ${result['message']}');
          return false;
        }
      } else {
        debugPrint('签名删除失败，状态码: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('删除签名时发生错误: $e');
      return false;
    }
  }
}
