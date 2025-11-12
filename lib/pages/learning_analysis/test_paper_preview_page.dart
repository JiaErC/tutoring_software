import 'package:flutter/material.dart';
import 'package:tutoring_software/data/generated_test_data.dart';
import 'package:tutoring_software/data/test_scoring_data.dart';

class TestPaperPreviewPage extends StatelessWidget {
  final GeneratedTestPaper testPaper;

  const TestPaperPreviewPage({Key? key, required this.testPaper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(testPaper.title),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // 下载试卷逻辑
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('试卷已保存到本地')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 试卷基本信息
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testPaper.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.subject),
                        const SizedBox(width: 5),
                        Text('科目: ${testPaper.subject}'),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.timer),
                        const SizedBox(width: 5),
                        Text('建议时长: ${testPaper.duration}分钟'),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.score),
                        const SizedBox(width: 5),
                        Text('总分: ${testPaper.totalScore}分'),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 5),
                        Text('学生: ${testPaper.studentName}'),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 5),
                        Text(
                            '生成时间: ${testPaper.generatedDate.year}-${testPaper.generatedDate.month.toString().padLeft(2, '0')}-${testPaper.generatedDate.day.toString().padLeft(2, '0')}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // 题目列表
            const Text(
              '题目列表:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            Expanded(
              child: ListView.builder(
                itemCount: testPaper.questions.length,
                itemBuilder: (context, index) {
                  final question = testPaper.questions[index];
                  return _buildQuestionCard(question, index + 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(dynamic question, int number) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '第$number题',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text('${question.score}分'),
                  backgroundColor: Colors.blue.withOpacity(0.2),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              question.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            
            // 题目类型标识
            Align(
              alignment: Alignment.centerRight,
              child: Chip(
                label: Text(_getQuestionTypeText(question.questionType)),
                backgroundColor: _getQuestionTypeColor(question.questionType),
              ),
            ),
            
            // 选项（如果是选择题）
            if (question.questionType == 'multiple_choice' && question.options != null)
              ..._buildMultipleChoiceOptions(question.options!),
            
            // 参考答案（在预览模式下显示）
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '参考答案:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    question.correctAnswer ?? '无',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildMultipleChoiceOptions(List<String> options) {
    final List<Widget> optionWidgets = [];
    for (int i = 0; i < options.length; i++) {
      optionWidgets.add(
        ListTile(
          leading: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.blue.withOpacity(0.2),
            child: Text(
              String.fromCharCode(65 + i), // A, B, C, D
              style: const TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),
          title: Text(options[i]),
        ),
      );
    }
    return optionWidgets;
  }
  
  String _getQuestionTypeText(String type) {
    switch (type) {
      case 'multiple_choice':
        return '选择题';
      case 'short_answer':
        return '简答题';
      case 'essay':
        return '论述题';
      default:
        return '未知题型';
    }
  }
  
  Color _getQuestionTypeColor(String type) {
    switch (type) {
      case 'multiple_choice':
        return Colors.blue.withOpacity(0.2);
      case 'short_answer':
        return Colors.orange.withOpacity(0.2);
      case 'essay':
        return Colors.purple.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }
}