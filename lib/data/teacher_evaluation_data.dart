import 'package:flutter/foundation.dart';

// 教师评价类
class TeacherReview {
  final String id;
  final String teacherName;
  final String studentId;
  final String studentName;
  final int rating; // 评分 1-5
  final String comment;
  final String date;

  TeacherReview({
    required this.id,
    required this.teacherName,
    required this.studentId,
    required this.studentName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

// 教师评价数据管理类
class TeacherEvaluationData extends ChangeNotifier {
  // 存储所有教师评价的列表
  List<TeacherReview> _reviews = [
    // 示例数据
    TeacherReview(
      id: '1',
      teacherName: '张老师',
      studentId: 'student_1',
      studentName: '张三',
      rating: 5,
      comment: '张老师教学非常认真负责，讲解清晰易懂，对学生的疑问总是耐心解答。',
      date: '2023-05-15',
    ),
    TeacherReview(
      id: '2',
      teacherName: '李老师',
      studentId: 'student_1',
      studentName: '张三',
      rating: 4,
      comment: '李老师专业知识扎实，课程内容丰富，但有时讲课速度稍快。',
      date: '2023-06-20',
    ),
    TeacherReview(
      id: '3',
      teacherName: '王老师',
      studentId: 'student_2',
      studentName: '李四',
      rating: 5,
      comment: '王老师非常关心学生的学习进展，经常主动了解我们的学习困难并提供帮助。',
      date: '2023-07-10',
    ),
    TeacherReview(
      id: '4',
      teacherName: '张老师',
      studentId: 'student_3',
      studentName: '王五',
      rating: 4,
      comment: '张老师的教学方法很有趣，能够激发我们的学习兴趣，但在课程安排上可以更紧凑一些。',
      date: '2023-08-05',
    ),
    TeacherReview(
      id: '5',
      teacherName: '赵老师',
      studentId: 'student_2',
      studentName: '李四',
      rating: 5,
      comment: '赵老师非常专业，能够根据每个学生的特点制定个性化的教学方案。',
      date: '2023-09-12',
    ),
  ];

  // 获取所有评价
  List<TeacherReview> get reviews => _reviews;

  // 添加新评价
  void addReview(TeacherReview review) {
    _reviews.add(review);
    notifyListeners();
  }

  // 获取特定教师的所有评价
  List<TeacherReview> getReviewsForTeacher(String teacherName) {
    return _reviews.where((review) => review.teacherName == teacherName).toList();
  }

  // 获取特定学生的所有评价
  List<TeacherReview> getEvaluationsForStudent(String studentId) {
    return _reviews.where((review) => review.studentId == studentId).toList();
  }

  // 获取特定教师的平均评分
  double getAverageRatingForTeacher(String teacherName) {
    final teacherReviews = getReviewsForTeacher(teacherName);
    if (teacherReviews.isEmpty) return 0.0;
    
    double totalRating = 0;
    for (var review in teacherReviews) {
      totalRating += review.rating;
    }
    
    return totalRating / teacherReviews.length;
  }

  // 获取特定教师的评价总数
  int getReviewCountForTeacher(String teacherName) {
    return getReviewsForTeacher(teacherName).length;
  }

  // 获取评价过特定教师的学生数量
  int getStudentCountForTeacher(String teacherName) {
    final teacherReviews = getReviewsForTeacher(teacherName);
    final studentIds = <String>{};
    for (var review in teacherReviews) {
      studentIds.add(review.studentId);
    }
    return studentIds.length;
  }
}