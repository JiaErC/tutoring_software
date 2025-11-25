import 'dart:convert';

import 'package:flutter/services.dart';

// 学科代码映射Map，用于存储学科名称到学科代码的映射
Map<String, String> subjectsCodeMap = {};

// 添加深拷贝辅助方法
Map<String, dynamic> deepCopyMap(Map<String, dynamic> source) {
  final result = <String, dynamic>{};
  source.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      result[key] = deepCopyMap(value);
    } else if (value is List) {
      result[key] = List.from(value);
    } else {
      result[key] = value;
    }
  });
  return result;
}

//把学科的各个最小学科都分发一个键值对，键为学科名字，值为false
Map<String, bool> initSubjectsBoolMap(Map<String, dynamic> source) {
  final result = <String, bool>{};
  source.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      result.addAll(initSubjectsBoolMap(value));
    } else if (value is List) {
      for (var element in value) {
        result[element] = false;
      }
    }
  });
  return result;
}

//把每个学科的最大学科配一个键值对，这个键位学科大类的名字，值为true
Map<String, bool> initBigSubjectsBoolMap(Map<String, dynamic> source) {
  final result = <String, bool>{};
  source.forEach((key, _) {
    result[key] = true;
  });
  return result;
}

// 加载学科代码映射文件
Future<void> loadSubjectsCodeMap() async {
  try {
    // 从assets加载JSON文件
    String data = await rootBundle.loadString('lib/data/subjects_code.json');
    // 解析JSON
    Map<String, dynamic> jsonData = json.decode(data);
    // 转换为Map<String, String>
    jsonData.forEach((key, value) {
      subjectsCodeMap[key] = value.toString();
    });
  } catch (e) {
    print('加载学科代码映射出错: $e');
  }
}

//把每个学科的选择情况通过键值对匹配到每个学科的学科号码中
Map<String, String> initSubjectsNumMap(Map<String, bool> subjectsBoolMap) {
  final result = <String, String>{};

  // 遍历学科选择情况，如果选择了该学科(true)，则将其添加到结果Map中
  subjectsBoolMap.forEach((subjectName, isSelected) {
    if (isSelected && subjectsCodeMap.containsKey(subjectName)) {
      result[subjectsCodeMap[subjectName]!] = subjectName;
    }
  });

  return result;
}