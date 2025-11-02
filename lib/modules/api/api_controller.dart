import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiController {
  //配置虚拟机的IP地址
  static const String vmIpAddress = '192.168.18.255';
  static const String backendPort = '8080';

  // 获取后端生成的UID
  Future<String> getUid() async {
    try {
      final result = await _generateUid();
      if (result['code'] == 200) {
        // 获取生成的UID
        // final num uidNum = result['data'] as num;
        // final String uidStr = uidNum.toString();
        final String uid = result['data'].toString();
        debugPrint('获取到了后端生成的UID: $uid');
        // 在这里使用UID
        return uid;
      } else {
        //处理非200响应：抛出带状态码的异常
        throw Exception('UID 生成失败，');
      }
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  //生成UID
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
    final String baseUrl = 'http://$vmIpAddress:$backendPort';
   try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/uid/generate'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
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
}
