class Comment {
  // 添加id字段
  String? id;
  // 保持studentUid和teacherUid字段
  String studentUid = "";
  String teacherUid = "";
  // 将comment字段重命名为content，与后端保持一致
  String content = "";
  // 将timeAt字段重命名为createdAt，与后端保持一致
  String createdAt = "";
  // 将rating类型从int改为String，与后端保持一致
  String rating = "";
  // 保持subject字段
  String subject = "";

  // 添加默认构造函数
  Comment();

  // 添加带参数的构造函数
  Comment.fromBackend({
    this.id,
    required this.studentUid,
    required this.teacherUid,
    required this.content,
    required this.rating,
    required this.createdAt,
    required this.subject,
  });

  // 添加从JSON解析的工厂方法
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment()
      ..id = json['id']?.toString()
      ..studentUid = json['studentUid']?.toString() ?? ''
      ..teacherUid = json['teacherUid']?.toString() ?? ''
      ..content = json['content'] ?? ''
      ..rating = json['rating'] ?? ''
      ..createdAt = json['createdAt'] ?? ''
      ..subject = json['subject'] ?? '';
  }

  // 添加转换为JSON的方法
  Map<String, dynamic> toJson() {
    return {
      'studentUid': studentUid,
      'teacherUid': teacherUid,
      'content': content,
      'rating': rating,
      'createdAt': createdAt,
      'subject': subject,
    };
  }
}