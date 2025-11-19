import 'dart:convert';

/// 师生关系实体类
class TSRelationship {
  /// 主键ID
  final int? id;
  
  /// 学生UID
  final int studentUid;
  
  /// 老师UID
  final int teacherUid;
  
  /// 默认构造函数
  TSRelationship({
    this.id,
    required this.studentUid,
    required this.teacherUid,
  });
  
  /// 从后端数据构造函数（处理数值类型转换）
  factory TSRelationship.fromBackend({
    dynamic id,
    required dynamic studentUid,
    required dynamic teacherUid,
  }) {
    return TSRelationship(
      id: id is int ? id : (id is String ? int.tryParse(id) : null),
      studentUid: studentUid is int ? studentUid : (studentUid is String ? int.parse(studentUid) : 0),
      teacherUid: teacherUid is int ? teacherUid : (teacherUid is String ? int.parse(teacherUid) : 0),
    );
  }
  
  /// 从JSON映射创建实例
  factory TSRelationship.fromJson(Map<String, dynamic> json) {
    return TSRelationship(
      id: json['id'] != null ? json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) : null,
      studentUid: json['studentUid'] != null ? 
          (json['studentUid'] is int ? json['studentUid'] : int.parse(json['studentUid'].toString())) : 0,
      teacherUid: json['teacherUid'] != null ? 
          (json['teacherUid'] is int ? json['teacherUid'] : int.parse(json['teacherUid'].toString())) : 0,
    );
  }
  
  /// 转换为JSON映射
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentUid': studentUid,
      'teacherUid': teacherUid,
    };
  }
  
  @override
  String toString() {
    return 'TSRelationship{id: $id, studentUid: $studentUid, teacherUid: $teacherUid}';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TSRelationship &&
           other.studentUid == studentUid &&
           other.teacherUid == teacherUid;
  }
  
  @override
  int get hashCode {
    return studentUid.hashCode ^ teacherUid.hashCode;
  }
}