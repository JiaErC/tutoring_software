import 'package:flutter/material.dart';
import 'package:tutoring_software/data/test_scoring_data.dart';

class TestScoringPage extends StatefulWidget {
  const TestScoringPage({Key? key}) : super(key: key);

  @override
  State<TestScoringPage> createState() => _TestScoringPageState();
}

class _TestScoringPageState extends State<TestScoringPage> {
  String selectedTeacherId = '1'; // 默认选择第一个老师

  @override
  Widget build(BuildContext context) {
    final testResults = TestScoringData.getResultsForTeacher(selectedTeacherId);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('试卷评阅'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 老师选择器
            Row(
              children: [
                const Text('选择老师:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedTeacherId,
                  items: const [
                    DropdownMenuItem(value: '1', child: Text('数学老师')),
                    DropdownMenuItem(value: '2', child: Text('英语老师')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTeacherId = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // 如果有试卷结果则显示，否则显示提示信息
            if (testResults.isEmpty)
              const Center(
                child: Text('暂无该老师的试卷评阅数据', style: TextStyle(fontSize: 18, color: Colors.grey)),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: testResults.length,
                  itemBuilder: (context, index) {
                    final result = testResults[index];
                    return _buildTestResultCard(result);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResultCard(StudentTestResult result) {
    // 获取试卷信息
    final testPaper = TestScoringData.getTestPaperById(result.testPaperId);
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 学生信息和试卷标题
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  result.studentName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text('${result.obtainedScore}/${testPaper?.totalScore ?? 'N/A'}'),
                  backgroundColor: _getScoreColor(result.obtainedScore.toDouble(), testPaper?.totalScore.toDouble() ?? 100.0),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              testPaper?.title ?? '未知试卷',
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),
            const SizedBox(height: 5),
            Text(
              '提交时间: ${result.submissionDate.year}-${result.submissionDate.month.toString().padLeft(2, '0')}-${result.submissionDate.day.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            
            // 题目得分详情
            const Text('题目得分详情:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...result.questionResults.asMap().entries.map((entry) {
              final index = entry.key;
              final questionResult = entry.value;
              // 获取题目信息
              final question = testPaper?.questions.firstWhere(
                (q) => q.id == questionResult.questionId,
                orElse: () => TestQuestion(
                  id: questionResult.questionId,
                  content: '未知题目',
                  score: 0,
                  questionType: 'unknown',
                ),
              );
              
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '题目 ${index + 1}: ${question?.content ?? '未知题目'}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Chip(
                          label: Text('${questionResult.obtainedScore}/${question?.score ?? 'N/A'}'),
                          backgroundColor: _getScoreColor(questionResult.obtainedScore, question?.score ?? 100),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    if (questionResult.studentAnswer != null)
                      Text('学生答案: ${questionResult.studentAnswer}'),
                    if (questionResult.evaluation != null)
                      Text(
                        '教师评语: ${questionResult.evaluation}',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                  ],
                ),
              );
            }).toList(),
            
            const SizedBox(height: 15),
            
            // 总体反馈
            const Text('总体反馈:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(result.feedback),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double score, double totalScore) {
    final percentage = score / totalScore;
    if (percentage >= 0.9) {
      return Colors.green.withOpacity(0.3);
    } else if (percentage >= 0.7) {
      return Colors.lightGreen.withOpacity(0.3);
    } else if (percentage >= 0.6) {
      return Colors.orange.withOpacity(0.3);
    } else {
      return Colors.red.withOpacity(0.3);
    }
  }
}