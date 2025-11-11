import 'package:tutoring_software/data/learning_analysis_data.dart';
import 'package:tutoring_software/data/test_scoring_data.dart';

class GeneratedTestPaper {
  final String id;
  final String title;
  final String subject;
  final int totalScore;
  final int duration; // in minutes
  final List<TestQuestion> questions;
  final String studentId;
  final String studentName;
  final DateTime generatedDate;

  GeneratedTestPaper({
    required this.id,
    required this.title,
    required this.subject,
    required this.totalScore,
    required this.duration,
    required this.questions,
    required this.studentId,
    required this.studentName,
    required this.generatedDate,
  });
}

class QuestionGenerator {
  // 根据学生薄弱知识点生成题目
  static List<TestQuestion> generateQuestionsForStudent(
    StudentPerformance performance,
    Map<String, dynamic> subjectsData,
  ) {
    final List<TestQuestion> questions = [];
    
    // 根据学生的学科和推荐内容生成题目
    final String subject = performance.subject;
    final String recommendation = performance.recommendation;
    
    // 解析推荐内容，确定需要加强的知识点
    final List<String> weakPoints = _extractWeakPoints(recommendation);
    
    // 为每个薄弱知识点生成题目
    for (int i = 0; i < weakPoints.length; i++) {
      final String weakPoint = weakPoints[i];
      
      // 生成不同类型的题目
      if (i % 3 == 0) {
        // 选择题
        questions.add(
          TestQuestion(
            id: 'gen_q_${performance.studentId}_${i + 1}',
            content: '关于${weakPoint}，以下说法正确的是？',
            score: 5,
            questionType: 'multiple_choice',
            options: [
              '选项A',
              '选项B',
              '选项C',
              '选项D'
            ],
            correctAnswer: '选项B',
          ),
        );
      } else if (i % 3 == 1) {
        // 简答题
        questions.add(
          TestQuestion(
            id: 'gen_q_${performance.studentId}_${i + 1}',
            content: '请简述${weakPoint}的核心概念和应用方法。',
            score: 10,
            questionType: 'short_answer',
            correctAnswer: '答案示例：${weakPoint}是...，其主要应用包括...',
          ),
        );
      } else {
        // 论述题
        questions.add(
          TestQuestion(
            id: 'gen_q_${performance.studentId}_${i + 1}',
            content: '请结合实际案例，论述${weakPoint}在${subject}学习中的重要性，并给出你的学习建议。',
            score: 15,
            questionType: 'essay',
            correctAnswer: '答案示例：${weakPoint}在${subject}中具有重要作用，具体体现在...',
          ),
        );
      }
    }
    
    // 如果没有识别出具体的薄弱点，则生成通用题目
    if (questions.isEmpty) {
      questions.addAll(_generateGenericQuestions(subject, performance.level));
    }
    
    return questions;
  }
  
  // 从推荐内容中提取薄弱知识点
  static List<String> _extractWeakPoints(String recommendation) {
    final List<String> weakPoints = [];
    
    // 这里可以根据实际的推荐内容格式进行解析
    // 简单示例：查找关键词
    if (recommendation.contains('函数')) {
      weakPoints.add('函数概念与性质');
    }
    if (recommendation.contains('计算')) {
      weakPoints.add('基础计算能力');
    }
    if (recommendation.contains('语法')) {
      weakPoints.add('语法规则');
    }
    if (recommendation.contains('词汇')) {
      weakPoints.add('词汇积累');
    }
    if (recommendation.contains('阅读')) {
      weakPoints.add('阅读理解');
    }
    if (recommendation.contains('写作')) {
      weakPoints.add('写作技巧');
    }
    if (recommendation.contains('实验')) {
      weakPoints.add('实验操作');
    }
    if (recommendation.contains('理论')) {
      weakPoints.add('理论理解');
    }
    
    // 如果没有找到具体关键词，添加通用薄弱点
    if (weakPoints.isEmpty) {
      weakPoints.addAll(['基础知识', '应用能力', '综合分析']);
    }
    
    return weakPoints;
  }
  
  // 生成通用题目
  static List<TestQuestion> _generateGenericQuestions(String subject, String level) {
    final List<TestQuestion> questions = [];
    
    // 根据学生水平生成不同难度的题目
    if (level == 'poor' || level == 'average') {
      // 基础题目
      questions.add(
        TestQuestion(
          id: 'gen_q_basic_1',
          content: '请回答${subject}的基本概念是什么？',
          score: 5,
          questionType: 'short_answer',
          correctAnswer: '${subject}是...',
        ),
      );
      
      questions.add(
        TestQuestion(
          id: 'gen_q_basic_2',
          content: '${subject}在实际生活中有哪些应用？',
          score: 10,
          questionType: 'essay',
          correctAnswer: '${subject}在生活中有多种应用，例如...',
        ),
      );
    } else {
      // 提高题目
      questions.add(
        TestQuestion(
          id: 'gen_q_advanced_1',
          content: '请分析${subject}中一个重要定理的证明过程及其应用。',
          score: 15,
          questionType: 'essay',
          correctAnswer: '该定理的证明过程如下：...，其主要应用包括...',
        ),
      );
      
      questions.add(
        TestQuestion(
          id: 'gen_q_advanced_2',
          content: '结合最新发展，谈谈${subject}的未来趋势。',
          score: 20,
          questionType: 'essay',
          correctAnswer: '${subject}的未来发展趋势主要体现在...',
        ),
      );
    }
    
    return questions;
  }
  
  // 生成完整的试卷
  static GeneratedTestPaper generateTestPaper(
    StudentPerformance performance,
    Map<String, dynamic> subjectsData,
  ) {
    final questions = generateQuestionsForStudent(performance, subjectsData);
    
    // 计算总分
    int totalScore = 0;
    for (var question in questions) {
      totalScore += question.score.toInt();
    }
    
    return GeneratedTestPaper(
      id: 'gen_tp_${performance.studentId}_${DateTime.now().millisecondsSinceEpoch}',
      title: '${performance.studentName}的个性化提升试卷(${performance.subject})',
      subject: performance.subject,
      totalScore: totalScore,
      duration: questions.length * 5, // 估计每题5分钟
      questions: questions,
      studentId: performance.studentId,
      studentName: performance.studentName,
      generatedDate: DateTime.now(),
    );
  }
}