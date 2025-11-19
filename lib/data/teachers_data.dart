class Teacher {
  final String id;
  final String name;
  final String subject;
  final String gender;
  final int age;
  final int experience;
  final String phone;
  final String email;
  final String location;
  final String education;
  final String certification;
  final double rating;
  final int studentCount;
  final int lessonCount;
  final String teachingStyle;
  final List<String> subjects;
  final List<String> achievements;
  final Map<String, String> schedule;
  final List<String> teachingMethods;

  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    required this.gender,
    required this.age,
    required this.experience,
    required this.phone,
    required this.email,
    required this.location,
    required this.education,
    required this.certification,
    required this.rating,
    required this.studentCount,
    required this.lessonCount,
    required this.teachingStyle,
    required this.subjects,
    required this.achievements,
    required this.schedule,
    required this.teachingMethods,
  });
}

class TeacherData {
  static final List<Teacher> teachers = [
    Teacher(
      id: '1',
      name: '张老师',
      subject: '数学',
      gender: '男',
      age: 35,
      experience: 10,
      phone: '138****8888',
      email: 'zhanglaoshi@example.com',
      location: '北京市海淀区',
      education: '北京师范大学',
      certification: '高级中学教师资格证',
      rating: 4.8,
      studentCount: 128,
      lessonCount: 256,
      teachingStyle: '张老师拥有丰富的教学经验，擅长启发式教学，能够根据学生的特点制定个性化的教学方案。教学风格严谨而不失亲和力，深受学生喜爱。',
      subjects: [
        '小学数学',
        '初中数学',
        '高中数学',
        '奥数',
        '考研数学',
      ],
      achievements: [
        '所带学生数学成绩平均提升20-30分',
        '2019年所带高三班级数学平均分115分',
        '多名学生考入重点大学',
        '获得市级优秀教师称号',
      ],
      schedule: {
        '工作日': '18:00-21:00',
        '周末': '9:00-17:00',
      },
      teachingMethods: [
        '线下面对面教学',
        '线上远程教学',
        '小班教学（最多5人）',
        '一对一辅导',
      ],
    ),
    Teacher(
      id: '2',
      name: '李老师',
      subject: '英语',
      gender: '女',
      age: 28,
      experience: 6,
      phone: '139****9999',
      email: 'lilaoshi@example.com',
      location: '北京市朝阳区',
      education: '北京外国语大学',
      certification: '高级中学教师资格证',
      rating: 4.9,
      studentCount: 95,
      lessonCount: 180,
      teachingStyle: '李老师具有海外留学背景，英语口语流利，擅长情景教学法，能够营造轻松愉快的学习氛围，让学生在互动中提高英语水平。',
      subjects: [
        '小学英语',
        '初中英语',
        '高中英语',
        '大学英语',
        '雅思',
        '托福',
      ],
      achievements: [
        '帮助50+学生提高雅思成绩1-2分',
        '多名学生考入国外知名大学',
        '获得区级优秀教师称号',
      ],
      schedule: {
        '工作日': '16:00-20:00',
        '周末': '10:00-18:00',
      },
      teachingMethods: [
        '线下面对面教学',
        '线上远程教学',
        '小组讨论式教学',
        '情景模拟教学',
      ],
    ),
    Teacher(
      id: '3',
      name: '王老师',
      subject: '物理',
      gender: '男',
      age: 42,
      experience: 15,
      phone: '137****7777',
      email: 'wanglaoshi@example.com',
      location: '北京市西城区',
      education: '清华大学',
      certification: '高级中学教师资格证',
      rating: 4.7,
      studentCount: 110,
      lessonCount: 220,
      teachingStyle: '王老师具有扎实的物理理论基础和丰富的教学经验，擅长通过实验和生活实例帮助学生理解抽象的物理概念，激发学生对物理学科的兴趣。',
      subjects: [
        '初中物理',
        '高中物理',
        '大学物理',
        '竞赛物理',
      ],
      achievements: [
        '所带学生物理竞赛获奖30+人次',
        '多名学生考入清华北大等顶尖高校',
        '发表多篇物理教学论文',
      ],
      schedule: {
        '工作日': '17:00-21:00',
        '周末': '8:00-16:00',
      },
      teachingMethods: [
        '实验教学',
        '理论结合实际',
        '一对一辅导',
        '竞赛辅导',
      ],
    ),
  ];
}