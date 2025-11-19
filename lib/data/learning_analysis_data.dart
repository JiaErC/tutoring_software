class StudentPerformance {
  final String studentId;
  final String studentName;
  final String subject;
  final double score;
  final DateTime date;
  final String level; // 'excellent', 'good', 'average', 'poor'
  final String recommendation;

  StudentPerformance({
    required this.studentId,
    required this.studentName,
    required this.subject,
    required this.score,
    required this.date,
    required this.level,
    required this.recommendation,
  });
}

class LearningAnalysis {
  final String teacherId;
  final List<StudentPerformance> performances;
  final Map<String, double> subjectAverages;
  final Map<String, int> levelDistribution; // e.g., {'excellent': 5, 'good': 10, ...}
  final DateTime analysisDate;

  LearningAnalysis({
    required this.teacherId,
    required this.performances,
    required this.subjectAverages,
    required this.levelDistribution,
    required this.analysisDate,
  });
}

class LearningAnalysisData {
  static final Map<String, List<LearningAnalysis>> _analysisData = {
    '1': [
      LearningAnalysis(
        teacherId: '1',
        performances: [
          StudentPerformance(
            studentId: 's001',
            studentName: '张小明',
            subject: '数学',
            score: 95.0,
            date: DateTime(2023, 10, 15),
            level: 'excellent',
            recommendation: '继续保持，可尝试挑战更高难度题目',
          ),
          StudentPerformance(
            studentId: 's002',
            studentName: '李小红',
            subject: '数学',
            score: 87.5,
            date: DateTime(2023, 10, 15),
            level: 'good',
            recommendation: '加强函数部分练习',
          ),
          StudentPerformance(
            studentId: 's003',
            studentName: '王小刚',
            subject: '数学',
            score: 72.0,
            date: DateTime(2023, 10, 15),
            level: 'average',
            recommendation: '需要加强基础计算能力',
          ),
        ],
        subjectAverages: {'数学': 84.83},
        levelDistribution: {'excellent': 1, 'good': 1, 'average': 1, 'poor': 0},
        analysisDate: DateTime(2023, 10, 15),
      ),
    ],
    '2': [
      LearningAnalysis(
        teacherId: '2',
        performances: [
          StudentPerformance(
            studentId: 's004',
            studentName: '赵小丽',
            subject: '英语',
            score: 92.0,
            date: DateTime(2023, 10, 20),
            level: 'excellent',
            recommendation: '口语表达能力优秀，可增加阅读量',
          ),
          StudentPerformance(
            studentId: 's005',
            studentName: '陈小强',
            subject: '英语',
            score: 78.5,
            date: DateTime(2023, 10, 20),
            level: 'average',
            recommendation: '需要加强语法和词汇积累',
          ),
        ],
        subjectAverages: {'英语': 85.25},
        levelDistribution: {'excellent': 1, 'good': 0, 'average': 1, 'poor': 0},
        analysisDate: DateTime(2023, 10, 20),
      ),
    ],
    '3': [
      LearningAnalysis(
        teacherId: '3',
        performances: [
          StudentPerformance(
            studentId: 's006',
            studentName: '刘小华',
            subject: '物理',
            score: 88.0,
            date: DateTime(2023, 10, 18),
            level: 'good',
            recommendation: '实验操作能力较强，理论理解需加强',
          ),
          StudentPerformance(
            studentId: 's007',
            studentName: '孙小美',
            subject: '物理',
            score: 94.5,
            date: DateTime(2023, 10, 18),
            level: 'excellent',
            recommendation: '综合能力优秀，可参加物理竞赛',
          ),
        ],
        subjectAverages: {'物理': 91.25},
        levelDistribution: {'excellent': 1, 'good': 1, 'average': 0, 'poor': 0},
        analysisDate: DateTime(2023, 10, 18),
      ),
    ],
  };

  static List<LearningAnalysis> getAnalysisForTeacher(String teacherId) {
    return _analysisData[teacherId] ?? [];
  }

  static StudentPerformance? getStudentAnalysis(String studentId, String teacherId) {
    final teacherAnalysis = _analysisData[teacherId];
    if (teacherAnalysis != null) {
      for (var analysis in teacherAnalysis) {
        for (var performance in analysis.performances) {
          if (performance.studentId == studentId) {
            return performance;
          }
        }
      }
    }
    return null;
  }
}