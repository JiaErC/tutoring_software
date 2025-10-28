import 'dart:convert';
import 'dart:io';
// import 'package:path_provider/path_provider.dart';

class FileUtils {
  // 读取JSON文件
  static Future<dynamic> readJsonFile() async {
    try {
      final file = File('lib\\data\\user_data.json');
      String contents = await file.readAsString();
      return json.decode(contents);
    } catch (e) {
      print('读取JSON文件失败: $e');
      return [];
    }
  }

  // 写入JSON文件
  static Future<void> writeJsonFile(dynamic data) async {
    try {
      final file = File('lib\\data\\user_data.json');
      await file.create(recursive: true);
      String jsonString = json.encode(data, toEncodable: _toEncodable);
      await file.writeAsString(jsonString, flush: true);
    } catch (e) {
      print('写入JSON文件失败: $e');
    }
  }

  // 处理不可直接序列化的对象
  static dynamic _toEncodable(dynamic object) {
    if (object is Set) {
      return object.toList();
    }
    return object;
  }
}