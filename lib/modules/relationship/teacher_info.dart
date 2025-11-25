class TeacherInfo {
  final int teacherUid; // 老师的uid
  final double rating; // 老师的评分
  final int comments; // 老师的评论数
  final List<String> subjects; // 老师的课程信息
  final int countSubjects; // 对口的课程数

  // 默认构造函数
  TeacherInfo({
    required this.teacherUid,
    required this.rating,
    required this.comments,
    required this.subjects,
    required this.countSubjects,
  });

  // fromJson 工厂方法 - 从JSON解析
  factory TeacherInfo.fromJson(Map<String, dynamic> json) {
    return TeacherInfo(
      teacherUid: json['teacherUid'] as int,
      rating: (json['rating'] as num).toDouble(),
      comments: json['comments'] as int,
      subjects: List<String>.from(json['subjects'] ?? []),
      countSubjects: json['countSubjects'] as int,
    );
  }

  // toJson 方法 - 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'teacherUid': teacherUid,
      'rating': rating,
      'comments': comments,
      'subjects': subjects,
      'countSubjects': countSubjects,
    };
  }

  // 从后端响应创建Teacher对象（处理可能的类型差异）
  factory TeacherInfo.fromBackend(Map<String, dynamic> json) {
    // 处理可能的类型转换，例如后端返回的是String而不是int
    return TeacherInfo(
      teacherUid: int.tryParse(json['teacherUid'].toString()) ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      comments: int.tryParse(json['comments']?.toString() ?? '0') ?? 0,
      subjects: List<String>.from(json['subjects'] ?? []),
      countSubjects:
          int.tryParse(json['countSubjects']?.toString() ?? '0') ?? 0,
    );
  }

  @override
  String toString() {
    return 'TeacherInfo{teacherUid: $teacherUid, rating: $rating, comments: $comments, subjects: $subjects, countSubjects: $countSubjects}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeacherInfo &&
        other.teacherUid == teacherUid &&
        other.rating == rating &&
        other.comments == comments &&
        other.subjects == subjects &&
        other.countSubjects == countSubjects;
  }

  @override
  int get hashCode {
    return teacherUid.hashCode ^
        rating.hashCode ^
        comments.hashCode ^
        subjects.hashCode ^
        countSubjects.hashCode;
  }
}
