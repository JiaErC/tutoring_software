import 'package:flutter/material.dart';
import 'package:tutoring_software/data/teachers_data.dart';

class TeacherInfoPage extends StatefulWidget {
  const TeacherInfoPage({super.key});

  @override
  State<TeacherInfoPage> createState() => _TeacherInfoPageState();
}

class _TeacherInfoPageState extends State<TeacherInfoPage> {
  bool _isFavorite = false;
  bool _isMyTutor = false; // 新增：标记是否为我的家教老师
  int _currentTeacherIndex = 0;

  Teacher get _currentTeacher => TeacherData.teachers[_currentTeacherIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('教师基本信息'),
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
                '教师信息',
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
                              _isFavorite = false; // 切换教师时重置收藏状态
                              _isMyTutor = false; // 切换教师时重置家教老师状态
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
                              _isFavorite = false; // 切换教师时重置收藏状态
                              _isMyTutor = false; // 切换教师时重置家教老师状态
                            });
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // 评分和统计数据
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Text(' ${_currentTeacher.rating}'),
                  const SizedBox(width: 20),
                  Text('${_currentTeacher.studentCount} 名学生'),
                  const SizedBox(width: 20),
                  Text('${_currentTeacher.lessonCount} 节课'),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                '基本信息',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('姓名: ${_currentTeacher.name}'),
              Text('性别: ${_currentTeacher.gender}'),
              Text('年龄: ${_currentTeacher.age}岁'),
              Text('教学经验: ${_currentTeacher.experience}年'),
              Text('所教学科: ${_currentTeacher.subject}'),
              Text('联系电话: ${_currentTeacher.phone}'),
              Text('邮箱: ${_currentTeacher.email}'),
              Text('所在地区: ${_currentTeacher.location}'),
              Text('毕业院校: ${_currentTeacher.education}'),
              Text('教师资格证: ${_currentTeacher.certification}'),
              const SizedBox(height: 20),
              const Text(
                '教学特点',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(_currentTeacher.teachingStyle),
              const SizedBox(height: 20),
              const Text(
                '可教授科目',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _currentTeacher.subjects
                    .map((subject) => Chip(label: Text(subject)))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                '教学成果',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._currentTeacher.achievements
                  .map((achievement) => Text('• $achievement'))
                  .toList(),
              const SizedBox(height: 20),
              const Text(
                '教学时间安排',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._currentTeacher.schedule.entries
                  .map((entry) => Text('• ${entry.key}：${entry.value}'))
                  .toList(),
              const SizedBox(height: 20),
              const Text(
                '教学方式',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._currentTeacher.teachingMethods
                  .map((method) => Text('• $method'))
                  .toList(),
              const SizedBox(height: 20),
              // 新增：设为我的家教老师开关
              Card(
                color: _isMyTutor ? Colors.blue.shade50 : Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '设为我的家教老师',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: _isMyTutor,
                        onChanged: (value) {
                          setState(() {
                            _isMyTutor = value;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isMyTutor 
                                  ? '已将${_currentTeacher.name}设为您的家教老师' 
                                  : '已取消将${_currentTeacher.name}设为您的家教老师'
                              ),
                            ),
                          );
                        },
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_isFavorite ? '已取消收藏' : '已收藏该教师')),
                      );
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFavorite ? Colors.red : Colors.blue,
                    ),
                    child: Row(
                      children: [
                        Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                        const SizedBox(width: 5),
                        const Text('收藏教师'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 跳转到评价页面
                      // Modular.to.pushNamed('/teacher_evaluation');
                    },
                    child: const Text('查看评价'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 预约课程功能
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('预约功能开发中...')),
                      );
                    },
                    child: const Text('预约课程'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}