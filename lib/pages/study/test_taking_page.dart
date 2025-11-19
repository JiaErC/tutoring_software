import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tutoring_software/data/generated_test_data.dart';
import 'package:tutoring_software/data/test_scoring_data.dart';

class TestTakingPage extends StatefulWidget {
  final GeneratedTestPaper testPaper;

  const TestTakingPage({Key? key, required this.testPaper}) : super(key: key);

  @override
  State<TestTakingPage> createState() => _TestTakingPageState();
}

class _TestTakingPageState extends State<TestTakingPage> {
  // 存储学生答案的映射
  final Map<String, dynamic> _studentAnswers = {};
  
  // 控制器列表，用于简答题和论述题
  final Map<String, TextEditingController> _textControllers = {};

  @override
  void initState() {
    super.initState();
    // 初始化文本控制器
    for (var question in widget.testPaper.questions) {
      if (question.questionType == 'short_answer' || question.questionType == 'essay') {
        _textControllers[question.id] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    // 释放文本控制器
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.testPaper.title),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // 保存答题卡功能
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('答题卡已保存')),
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
                      widget.testPaper.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.subject),
                        const SizedBox(width: 5),
                        Text('科目: ${widget.testPaper.subject}'),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.timer),
                        const SizedBox(width: 5),
                        Text('建议时长: ${widget.testPaper.duration}分钟'),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.score),
                        const SizedBox(width: 5),
                        Text('总分: ${widget.testPaper.totalScore}分'),
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
                itemCount: widget.testPaper.questions.length,
                itemBuilder: (context, index) {
                  final question = widget.testPaper.questions[index];
                  return _buildQuestionCard(question, index + 1);
                },
              ),
            ),
            
            // 提交按钮
            Center(
              child: ElevatedButton(
                onPressed: _submitTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  '提交试卷',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(TestQuestion question, int number) {
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
              ..._buildMultipleChoiceOptions(question, number),
            
            // 简答题或论述题输入框
            if (question.questionType == 'short_answer' || question.questionType == 'essay')
              _buildTextAnswerField(question),
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildMultipleChoiceOptions(TestQuestion question, int number) {
    final List<Widget> optionWidgets = [];
    final selectedOption = _studentAnswers[question.id];
    
    for (int i = 0; i < question.options!.length; i++) {
      optionWidgets.add(
        RadioListTile<String>(
          title: Text(question.options![i]),
          value: question.options![i],
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              _studentAnswers[question.id] = value;
            });
          },
        ),
      );
    }
    
    return optionWidgets;
  }
  
  Widget _buildTextAnswerField(TestQuestion question) {
    final controller = _textControllers[question.id]!;
    
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: controller,
        maxLines: question.questionType == 'essay' ? 8 : 4,
        decoration: const InputDecoration(
          hintText: '请输入您的答案...',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          _studentAnswers[question.id] = value;
        },
      ),
    );
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
        return Colors.green.withOpacity(0.2);
      case 'essay':
        return Colors.orange.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }
  
  void _submitTest() {
    // 检查是否有未完成的题目
    int answeredCount = _studentAnswers.length;
    int totalQuestions = widget.testPaper.questions.length;
    
    if (answeredCount < totalQuestions) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('提示'),
          content: Text('您还有${totalQuestions - answeredCount}道题未作答，确定要提交吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processTestSubmission();
              },
              child: const Text('确定提交'),
            ),
          ],
        ),
      );
    } else {
      _processTestSubmission();
    }
  }
  
  void _processTestSubmission() {
    // 处理试卷提交逻辑
    // 这里应该将答案发送到服务器或保存到本地
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('试卷已提交，正在处理中...')),
    );
    
    // 返回到试卷列表页面
    Modular.to.pop();
  }
}