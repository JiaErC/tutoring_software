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