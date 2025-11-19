import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tutoring_software/data/generated_test_data.dart';

class TestListPage extends StatefulWidget {
  const TestListPage({super.key});

  @override
  State<TestListPage> createState() => _TestListPageState();
}

class _TestListPageState extends State<TestListPage> {
  // 模拟试卷数据
  final List<GeneratedTestPaper> _testPapers = [
    GeneratedTestPaper(
      id: 'test_001',
      title: '数学基础测试卷',
      subject: '数学',
      totalScore: 100,
      duration: 90,
      questions: [],
      studentId: 'student_001',
      studentName: '张三',
      generatedDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    GeneratedTestPaper(
      id: 'test_002',
      title: '英语语法测试卷',
      subject: '英语',
      totalScore: 100,
      duration: 60,
      questions: [],
      studentId: 'student_001',
      studentName: '张三',
      generatedDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    GeneratedTestPaper(
      id: 'test_003',
      title: '物理力学测试卷',
      subject: '物理',
      totalScore: 120,
      duration: 120,
      questions: [],
      studentId: 'student_001',
      studentName: '张三',
      generatedDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('试卷列表'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '待完成试卷',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _testPapers.length,
                itemBuilder: (context, index) {
                  final testPaper = _testPapers[index];
                  return _buildTestPaperCard(testPaper);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestPaperCard(GeneratedTestPaper testPaper) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    testPaper.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Chip(
                  label: Text(testPaper.subject),
                  backgroundColor: Colors.blue.withOpacity(0.2),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.timer, size: 16),
                const SizedBox(width: 5),
                Text('${testPaper.duration}分钟'),
                const SizedBox(width: 20),
                const Icon(Icons.score, size: 16),
                const SizedBox(width: 5),
                Text('${testPaper.totalScore}分'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 5),
                Text(
                    '${testPaper.generatedDate.year}-${testPaper.generatedDate.month.toString().padLeft(2, '0')}-${testPaper.generatedDate.day.toString().padLeft(2, '0')}'),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // 导航到试卷答题页面
                Modular.to.pushNamed('/study/test_taking', arguments: testPaper);
              },
              child: const Text('开始答题'),
            ),
          ],
        ),
      ),
    );
  }
}