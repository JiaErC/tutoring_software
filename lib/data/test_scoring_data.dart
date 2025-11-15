class TestPaper {
  final String id;
  final String title;
  final String subject;
  final int totalScore;
  final int duration; // in minutes
  final List<TestQuestion> questions;

  TestPaper({
    required this.id,
    required this.title,
    required this.subject,
    required this.totalScore,
    required this.duration,
    required this.questions,
  });
}

class TestQuestion {
  final String id;
  final String content;
  final double score;
  final String questionType; // 'multiple_choice', 'short_answer', 'essay'
  final List<String>? options; // for multiple choice
  final String? correctAnswer;

  TestQuestion({
    required this.id,
    required this.content,
    required this.score,
    required this.questionType,
    this.options,
    this.correctAnswer,
  });
}

class StudentTestResult {
  final String studentId;
  final String studentName;
  final String testPaperId;
  final double obtainedScore;
  final DateTime submissionDate;
  final List<QuestionResult> questionResults;
  final String feedback;

  StudentTestResult({
    required this.studentId,
    required this.studentName,
    required this.testPaperId,
    required this.obtainedScore,
    required this.submissionDate,
    required this.questionResults,
    required this.feedback,
  });
}

class QuestionResult {
  final String questionId;
  final double obtainedScore;
  final String? studentAnswer;
  final String? evaluation; // teacher's evaluation

  QuestionResult({
    required this.questionId,
    required this.obtainedScore,
    this.studentAnswer,
    this.evaluation,
  });
}

class TestScoringData {
  static final List<TestPaper> testPapers = [
    TestPaper(
      id: 'tp001',
      title: '高一数学期中考试',
      subject: '数学',
      totalScore: 150,
      duration: 120,
      questions: [
        TestQuestion(
          id: 'q1',
          content: '已知函数f(x)=2x+3，求f(5)的值。',
          score: 10,
          questionType: 'short_answer',
          correctAnswer: '13',
        ),
        TestQuestion(
          id: 'q2',
          content: '解方程：2x + 5 = 15',
          score: 10,
          questionType: 'short_answer',
          correctAnswer: 'x=5',
        ),
      ],
    ),
    TestPaper(
      id: 'tp002',
      title: '高二英语期末考试',
      subject: '英语',
      totalScore: 150,
      duration: 120,
      questions: [
        TestQuestion(
          id: 'q1',
          content: 'Choose the correct sentence:',
          score: 5,
          questionType: 'multiple_choice',
          options: ['He go to school.', 'He goes to school.', 'He going to school.'],
          correctAnswer: 'He goes to school.',
        ),
      ],
    ),
  ];

  static final Map<String, List<StudentTestResult>> _testResults = {
    '1': [
      StudentTestResult(
        studentId: 's001',
        studentName: '张小明',
        testPaperId: 'tp001',
        obtainedScore: 135.0,
        submissionDate: DateTime(2023, 10, 25),
        questionResults: [
          QuestionResult(
            questionId: 'q1',
            obtainedScore: 10.0,
            studentAnswer: '13',
            evaluation: '正确',
          ),
          QuestionResult(
            questionId: 'q2',
            obtainedScore: 9.0,
            studentAnswer: 'x=5',
            evaluation: '正确，步骤略显简略',
          ),
        ],
        feedback: '整体表现优秀，计算准确度高，继续保持。',
      ),
    ],
    '2': [
      StudentTestResult(
        studentId: 's004',
        studentName: '赵小丽',
        testPaperId: 'tp002',
        obtainedScore: 138.0,
        submissionDate: DateTime(2023, 10, 28),
        questionResults: [
          QuestionResult(
            questionId: 'q1',
            obtainedScore: 5.0,
            studentAnswer: 'He goes to school.',
            evaluation: '正确',
          ),
        ],
        feedback: '语言基础扎实，语法掌握良好。',
      ),
    ],
  };

  static List<StudentTestResult> getResultsForTeacher(String teacherId) {
    return _testResults[teacherId] ?? [];
  }

  static TestPaper? getTestPaperById(String id) {
    try {
      return testPapers.firstWhere((paper) => paper.id == id);
    } catch (e) {
      return null;
    }
  }
}