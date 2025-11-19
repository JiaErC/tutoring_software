import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/modules/api/api_settings.dart';
import 'package:tutoring_software/modules/status/status_controller.dart';
import 'package:tutoring_software/utils/storage.dart';

part 'signature_controller.g.dart';

class SignatureController = _SignatureController with _$SignatureController;

abstract class _SignatureController with Store {
  // API 基础路径
  final String signatureBaseUrl = '$baseUrl/api/user-signatures';
  //引入status
  final StatusController statusController = Modular.get<StatusController>();

  //打开签名盒子
  var signatureBox = GStorage.signatureBox;

  //当前uid的签名是多少
  @observable
  String uSignature = '';
  //是否有签名
  @observable
  bool hasSignature = false;

  //初始化获取签名
  @action
  Future<void> init(String uid) async {
    // 修复：安全类型检查，确保赋值为 String
    String? signature = await getSignature(uid);
    if (signature != null) {
      uSignature = signature;
      hasSignature = true;
    }else{
      hasSignature = false;
      uSignature = '';
    }
    debugPrint('signature_controller.dart 获取到的签名是: $signature');
  }

  // 存储签名
  @action
  Future<bool> saveSignature(String uid, String signature) async {
    try {
      // 先检查签名是否已存在
      String? existingSignature = await getSignature(uid);
      if (existingSignature != null) {
        // 如果已存在，调用更新方法
        return await updateSignature(uid, signature);
      } else {
        final response = await http.post(
          Uri.parse('$signatureBaseUrl/save'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'uid': uid, 'signatures': signature}),
        );

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          if (result['code'] == 200) {
            //本地存储
            signatureBox.put(uid, signature);
            uSignature = signature;
            hasSignature = true;
            debugPrint('signature_controller.dart 签名保存成功: $signature');
            return true;
          } else {
            debugPrint('signature_controller.dart 签名保存失败: ${result['message']}');
            return false;
          }
        } else {
          debugPrint('signature_controller.dart 签名保存失败，状态码: ${response.statusCode}');
          return false;
        }
      }
    } catch (e) {
      debugPrint('signature_controller.dart 保存签名时发生错误: $e');
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
          //本地存储
          signatureBox.put(uid, signature);
          uSignature = signature;
          hasSignature = true;
          debugPrint('signature_controller.dart_签名更新成功: $signature');
          return true;
        } else {
          debugPrint('signature_controller.dart_签名更新失败: ${result['message']}');
          return false;
        }
      } else {
        debugPrint('signature_controller.dart_签名更新失败，状态码: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('signature_controller.dart_更新签名时发生错误: $e');
      return false;
    }
  }

  // 获取签名
  @action
  Future<String?> getSignature(String uid) async {
    try {
      // 先从本地存储中获取签名
      final localSignature = signatureBox.get(uid);
      if (localSignature != null) {
        debugPrint('signature_controller.dart_从本地存储获取到的签名: $localSignature');
        return localSignature;
      }

      // 如果本地没有签名，则从后端获取
      final response = await http.get(
        Uri.parse('$signatureBaseUrl/get/$uid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] == 200) {
          final signature = result['data']['signatures'];
          // 保存到本地存储
          signatureBox.put(uid, signature);
          debugPrint('signature_controller.dart_从后端获取到的签名: $signature');
          return signature;
        } else {
          debugPrint('signature_controller.dart_获取签名失败: ${result['message']}');
          return null;
        }
      } else {
        debugPrint('signature_controller.dart_获取签名失败，状态码: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('signature_controller.dart_获取签名时发生错误: $e');
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
          // 从本地存储中删除
          signatureBox.delete(uid);
          debugPrint('signature_controller.dart_签名删除成功');
          return true;
        } else {
          debugPrint('signature_controller.dart_签名删除失败: ${result['message']}');
          return false;
        }
      } else {
        debugPrint('signature_controller.dart_签名删除失败，状态码: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('signature_controller.dart_删除签名时发生错误: $e');
      return false;
    }
  }
}
