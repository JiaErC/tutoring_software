import 'package:flutter/material.dart';
import 'package:tutoring_software/data/teachers_data.dart';

class TeacherEvaluationPage extends StatefulWidget {
  const TeacherEvaluationPage({super.key});

  @override
  State<TeacherEvaluationPage> createState() => _TeacherEvaluationPageState();
}

class _TeacherEvaluationPageState extends State<TeacherEvaluationPage> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();
  int _currentTeacherIndex = 0;
  
  // 每个教师的评价数据
  final Map<String, List<Map<String, dynamic>>> _allReviews = {
    '1': [
      {
        'name': '李同学',
        'rating': 5.0,
        'comment': '张老师讲解非常清晰，让我对数学产生了浓厚的兴趣！',
        'date': '2023-10-15',
      },
      {
        'name': '王同学',
        'rating': 4.5,
        'comment': '老师很有耐心，能够根据我的学习情况调整教学方法。',
        'date': '2023-09-22',
      },
      {
        'name': '赵同学',
        'rating': 5.0,
        'comment': '张老师的教学经验丰富，帮助我在短时间内提高了数学成绩。',
        'date': '2023-08-30',
      },
    ],
    '2': [
      {
        'name': '陈同学',
        'rating': 4.8,
        'comment': '李老师非常专业，对英语语法的讲解深入浅出。',
        'date': '2023-11-05',
      },
      {
        'name': '刘同学',
        'rating': 4.6,
        'comment': '老师的口语练习方法很有效，我的英语口语提高了很多。',
        'date': '2023-10-18',
      },
    ],
    '3': [
      {
        'name': '孙同学',
        'rating': 4.9,
        'comment': '王老师的物理课生动有趣，让复杂的概念变得容易理解。',
        'date': '2023-11-10',
      },
      {
        'name': '周同学',
        'rating': 4.7,
        'comment': '老师总是鼓励我们提问，营造了很好的学习氛围。',
        'date': '2023-10-25',
      },
      {
        'name': '吴同学',
        'rating': 5.0,
        'comment': '通过王老师的辅导，我的物理成绩从及格线提升到了优秀。',
        'date': '2023-09-30',
      },
    ],
  };

  List<Map<String, dynamic>> get _currentTeacherReviews =>
      _allReviews[TeacherData.teachers[_currentTeacherIndex].id] ?? [];

  Teacher get _currentTeacher => TeacherData.teachers[_currentTeacherIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('评价教师'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '教师评价',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // 添加前后切换按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _currentTeacherIndex > 0
                        ? () {
                            setState(() {
                              _currentTeacherIndex--;
                              _rating = 0.0; // 切换教师时重置评分
                            });
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/teacher_avatar.png'),
                    ),
                    title: Text(_currentTeacher.name),
                    subtitle: Text('${_currentTeacher.subject}教师'),
                  ),
                  IconButton(
                    onPressed: _currentTeacherIndex < TeacherData.teachers.length - 1
                        ? () {
                            setState(() {
                              _currentTeacherIndex++;
                              _rating = 0.0; // 切换教师时重置评分
                            });
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 教师评分统计
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '教师评分统计',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${_currentTeacher.rating}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const Text('综合评分'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${_currentTeacherReviews.length}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const Text('评价总数'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${_currentTeacher.studentCount}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              const Text('学生数量'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '评分',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('点击星星评分:'),
                  const SizedBox(width: 10),
                  ...List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1.0;
                        });
                      },
                    );
                  }),
                  Text('$_rating'),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                '评价内容',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _reviewController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: '请输入您对教师的评价...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_reviewController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('请输入评价内容')),
                      );
                      return;
                    }
                    
                    // 添加新评价到对应教师的列表
                    setState(() {
                      final teacherId = _currentTeacher.id;
                      if (!_allReviews.containsKey(teacherId)) {
                        _allReviews[teacherId] = [];
                      }
                      _allReviews[teacherId]!.insert(0, {
                        'name': '我',
                        'rating': _rating,
                        'comment': _reviewController.text,
                        'date': DateTime.now().toString().split(' ')[0],
                      });
                    });
                    
                    // 显示成功消息
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('评价提交成功')),
                    );
                    
                    // 清空输入
                    _reviewController.clear();
                    setState(() {
                      _rating = 0.0;
                    });
                  },
                  child: const Text('提交评价'),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '学生评价',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_currentTeacherReviews.length} 条评价',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _currentTeacherReviews.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          '暂无评价，快来发表第一个评价吧！',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _currentTeacherReviews.length,
                      itemBuilder: (context, index) {
                        final review = _currentTeacherReviews[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      review['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      review['date'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      i < review['rating'] ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                      size: 18,
                                    );
                                  }),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  review['comment'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}