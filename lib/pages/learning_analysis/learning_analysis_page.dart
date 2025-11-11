import 'package:flutter/material.dart';
import 'package:tutoring_software/data/learning_analysis_data.dart';
import 'package:tutoring_software/data/generated_test_data.dart';
import 'package:tutoring_software/pages/learning_analysis/test_paper_preview_page.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class LearningAnalysisPage extends StatefulWidget {
  const LearningAnalysisPage({Key? key}) : super(key: key);

  @override
  State<LearningAnalysisPage> createState() => _LearningAnalysisPageState();
}

class _LearningAnalysisPageState extends State<LearningAnalysisPage> {
  String selectedTeacherId = '1'; // 默认选择第一个老师

  @override
  Widget build(BuildContext context) {
    final analysisList = LearningAnalysisData.getAnalysisForTeacher(selectedTeacherId);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('学生学情分析'),
        backgroundColor: Colors.blueAccent,
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
                    DropdownMenuItem(value: '3', child: Text('物理老师')),
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
            
            // 如果有数据分析则显示，否则显示提示信息
            if (analysisList.isEmpty)
              const Center(
                child: Text('暂无该老师的学情分析数据', style: TextStyle(fontSize: 18, color: Colors.grey)),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: analysisList.length,
                  itemBuilder: (context, index) {
                    final analysis = analysisList[index];
                    return _buildAnalysisCard(analysis);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisCard(LearningAnalysis analysis) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分析日期
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '分析日期: ${analysis.analysisDate.year}-${analysis.analysisDate.month.toString().padLeft(2, '0')}-${analysis.analysisDate.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '科目平均分: ${analysis.subjectAverages.values.first.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            // 等级分布饼图占位符（实际项目中可以使用图表库）
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('等级分布图表 (实际项目中会显示可视化图表)'),
              ),
            ),
            const SizedBox(height: 10),
            
            // 等级分布详情
            const Text('等级分布:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Wrap(
              spacing: 10,
              children: analysis.levelDistribution.entries.map((entry) {
                return Chip(
                  label: Text('${entry.key}: ${entry.value}人'),
                  backgroundColor: _getLevelColor(entry.key),
                );
              }).toList(),
            ),
            const SizedBox(height: 15),
            
            // 学生表现列表
            const Text('学生表现详情:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...analysis.performances.map((performance) {
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
                          performance.studentName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Chip(
                          label: Text(performance.level),
                          backgroundColor: _getLevelColor(performance.level),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text('科目: ${performance.subject}'),
                    Text('得分: ${performance.score}'),
                    const SizedBox(height: 5),
                    Text(
                      '建议: ${performance.recommendation}',
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 10),
                    // 生成试卷按钮
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _generateTestPaper(context, performance),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('生成个性化提升试卷'),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'excellent':
        return Colors.green.withOpacity(0.3);
      case 'good':
        return Colors.lightGreen.withOpacity(0.3);
      case 'average':
        return Colors.orange.withOpacity(0.3);
      case 'poor':
        return Colors.red.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }
  
  // 生成个性化试卷
  void _generateTestPaper(BuildContext context, StudentPerformance performance) async {
    try {
      // 加载科目数据
      final String subjectsDataString = await rootBundle.loadString('lib/data/subjects_data.json');
      final Map<String, dynamic> subjectsData = json.decode(subjectsDataString);
      
      // 生成试卷
      final generatedTestPaper = QuestionGenerator.generateTestPaper(performance, subjectsData);
      
      // 导航到试卷预览页面
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestPaperPreviewPage(testPaper: generatedTestPaper),
          ),
        );
      }
    } catch (e) {
      // 显示错误提示
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('生成试卷失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}