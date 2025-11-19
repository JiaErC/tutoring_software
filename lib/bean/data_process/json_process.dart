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
