class Teacher {
  final int? id; // 自增ID，对应BIGSERIAL
  final int teacherUid; // 老师的uid
  final String rating; // 老师的评分
  final String subjectCode; // 老师教学的学科号（六位数字组成的字符串）

  // 默认构造函数
  Teacher({
    this.id,
    required this.teacherUid,
    required this.rating,
    required this.subjectCode,
  });

  // fromJson 工厂方法 - 从JSON解析
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as int?,
      teacherUid: json['teacherUid'] as int,
      rating: json['rating'] as String,
      subjectCode: json['subjectCode'] as String,
    );
  }

  // toJson 方法 - 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacherUid': teacherUid,
      'rating': rating,
      'subjectCode': subjectCode,
    };
  }

  // 从后端响应创建Teacher对象（处理可能的类型差异）
  factory Teacher.fromBackend(Map<String, dynamic> json) {
    // 处理可能的类型转换，例如后端返回的是String而不是int
    return Teacher(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      teacherUid: int.tryParse(json['teacherUid'].toString()) ?? 0,
      rating: json['rating']?.toString() ?? '',
      subjectCode: json['subjectCode']?.toString() ?? '',
    );
  }

  @override
  String toString() {
    return 'Teacher{id: $id, teacherUid: $teacherUid, rating: $rating, subjectCode: $subjectCode}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Teacher &&
        other.id == id &&
        other.teacherUid == teacherUid &&
        other.rating == rating &&
        other.subjectCode == subjectCode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        teacherUid.hashCode ^
        rating.hashCode ^
        subjectCode.hashCode;
  }
}
