import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:getwidget/getwidget.dart';

import 'package:tutoring_software/modules/status/status_controller.dart';
import 'package:tutoring_software/pages/subjects/subjects_controller.dart';
import 'package:tutoring_software/pages/selecter/selecter_controller.dart';
import 'package:tutoring_software/bean/widgets/widgets_builder.dart';

class SelecterPage extends StatefulWidget {
  const SelecterPage({super.key});

  @override
  State<SelecterPage> createState() => _SelecterPageState();
}

class _SelecterPageState extends State<SelecterPage> {
  //引入各种控制器
  final StatusController _statusController = Modular.get<StatusController>();
  final SubjectsController _subjectsController =
      Modular.get<SubjectsController>();
  final SelecterController _selecterController =
      Modular.get<SelecterController>();

  //文本控制器
  final TextEditingController _ratingTextController = TextEditingController(
    text: '0',
  );
  final TextEditingController _minCommentController = TextEditingController(
    text: '',
  );
  final TextEditingController _maxCommentController = TextEditingController(
    text: '',
  );

  //初始化
  @override
  void initState() {
    super.initState();
    //初始化
    _selecterController.init(
      _subjectsController.studySubjects,
      _subjectsController.teachSubjects,
    );
  }

  //文字边框的颜色设置
  Color _getRoleColor() {
    return !_statusController.isTeacher
        ? Colors.green.shade600
        : Colors.red.shade600;
  }

  //背景的颜色设置
  Color _getBackgroundColor() {
    return !_statusController.isTeacher
        ? Colors.green.shade100
        : Colors.red.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              _buildSubjectsContainer(),
              _buildRatingFilter(),
              _buildCommentFilter(),
              _buildCancelAndConfirmButton(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  //制作GFAppBar
  PreferredSizeWidget _buildAppBar() {
    return GFAppBar(
      title: const Text('选择合适的老师'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // 返回上一页
          Modular.to.pop();
        },
      ),
    );
  }

  //制作筛选窗口
  Widget _buildSubjectsContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.black87, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        //无论什么时候都可以使用滚动条
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_buildSubjects()],
        ),
      ),
    );
  }

  //接下来制作显示老师或者学生学习的各个学科
  Widget _buildSubjects() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildBigSubjects(),
      ),
    );
  }

  //箭头形状显示选择的学科大类
  List<Widget> _buildBigSubjects() {
    List<Widget> list = [];
    Map<String, dynamic> subjects = !_statusController.isTeacher
        ? _selecterController.uStudySubjects
        : _selecterController.uTeachSubjects;
    Map<String, bool> isViewSubjects = !_statusController.isTeacher
        ? _selecterController.isViewStudySubjects
        : _selecterController.isViewTeachSubjects;
    subjects.forEach((bigSubject, smallSubjects) {
      list.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              margin: EdgeInsets.only(top: 6),
              duration: Duration(milliseconds: 150),
              width: 200,
              height: 40,
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  bottomLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomRight: Radius.circular(20),
                ),
                border: Border.all(color: _getRoleColor(), width: 2),
              ),
              child: TextButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bigSubject,
                      style: TextStyle(
                        color: _getRoleColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8), // 文本和图标之间的间距
                    Icon(
                      (isViewSubjects[bigSubject] ?? true)
                          ? Icons.arrow_drop_down
                          : Icons.arrow_right,
                      color: _getRoleColor(),
                      size: 40,
                    ),
                  ],
                ),
                onPressed: () => setState(() {
                  debugPrint("是否展开：${isViewSubjects[bigSubject]}");
                  _selecterController.changeViewStudySubjects(bigSubject);
                }),
              ),
            ),
            isViewSubjects[bigSubject] ?? true
                ? Column(children: _buildSmallSubjects(smallSubjects))
                : SizedBox.shrink(), //这里是学科栏目
          ],
        ),
      );
    });
    return list;
  }

  //小学科按钮
  List<Widget> _buildSmallSubjects(bs) {
    List<Widget> list = [];
    bs.forEach((smallSubject, value) {
      list.add(
        Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              AnimatedContainer(
                margin: EdgeInsets.only(top: 4),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    bottomLeft: Radius.zero,
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border.all(color: _getRoleColor(), width: 2),
                ),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Text(
                    smallSubject,
                    key: ValueKey<String>('text_\${smallSubject}'), // 修改为唯一的key
                    style: TextStyle(
                      color: _getRoleColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              _buildLastSubjects(value),
            ], //添加了小学科
          ),
        ),
      );
    });
    return list;
  }

  //获取每个科目
  Widget _buildLastSubjects(ss) {
    List<Widget> list = [];
    //创建学科和选择学科
    // Map<String, dynamic> subjects = _statusController.isTeacher
    //     ? _selecterController.uTeachSubjects
    //     : _selecterController.uStudySubjects;
    Map<String, bool> subjectsSelectedMap = _statusController.isTeacher
        ? _selecterController.selectedTeachSubjects
        : _selecterController.selectedStudySubjects;
    ss.forEach((s) {
      list.add(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            bool isSelected = subjectsSelectedMap[s] ?? false; // 用于跟踪当前按钮是否被选中
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? _getBackgroundColor() // 选中时的背景色
                    : Colors.transparent, // 未选中时透明
                border: Border.all(color: _getRoleColor(), width: 2),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    if (subjectsSelectedMap.containsKey(s)) {
                      subjectsSelectedMap[s] = !subjectsSelectedMap[s]!;
                    } else {
                      subjectsSelectedMap[s] = true;
                    }
                  });
                },
                child: Text(
                  s,
                  style: TextStyle(
                    color: _getRoleColor(),
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
    // 返回一个有边框的Container容器
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 5),
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        decoration: BoxDecoration(
          border: Border.all(color: _getRoleColor(), width: 2),
        ),
        // 移除Wrap，直接在ScrollView中放置Row
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // 添加physics参数确保滚动体验
          physics: AlwaysScrollableScrollPhysics(),
          child: Row(children: list),
        ),
      ),
    );
  }

  //创建一个评分操作的栏目，筛选多少分以上的老师
  Widget _buildRatingFilter() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 60),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '筛选评分',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              // 横向滑块
              Expanded(
                child: Slider(
                  min: 0,
                  max: 100,
                  value: 20 * _selecterController.rating.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _selecterController.rating = _convertToFivePointScale(
                        value,
                      );
                      _ratingTextController.text = value.toInt().toString();
                    });
                  },
                  activeColor: Colors.blueAccent,
                  inactiveColor: Colors.grey,
                ),
              ),
              SizedBox(width: 10),
              // 数字输入框
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _ratingTextController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    // 验证输入值
                    int? val = int.tryParse(value);
                    if (val != null && val >= 0 && val <= 100) {
                      setState(() {
                        _selecterController.rating = _convertToFivePointScale(
                          val.toDouble(),
                        );
                      });
                    } else if (value.isEmpty) {
                      setState(() {
                        _selecterController.rating = 0;
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: 10),
              // 5分制显示框
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${_selecterController.rating.toStringAsFixed(2)}分',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _convertToFivePointScale(double rating) {
    return rating / 20;
  }

Widget _buildCommentFilter() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 60),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '筛选评价数量',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // 最小值输入框
            Expanded(
              child: TextField(
                controller: _minCommentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '最小值',
                  border: OutlineInputBorder(),
                  hintText: '0',
                ),
                onChanged: (value) {
                  // 验证输入值
                  if (value.isEmpty) {
                    _selecterController.minComment = 0;
                  } else {
                    int? minVal = int.tryParse(value);
                    if (minVal != null && minVal >= 0) {
                      _selecterController.minComment = minVal;
                    }
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            // 最大值输入框
            Expanded(
              child: TextField(
                controller: _maxCommentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '最大值',
                  border: OutlineInputBorder(),
                  hintText: '无限',
                ),
                onChanged: (value) {
                  // 验证输入值
                  if (value.isEmpty) {
                    // 空值表示无限
                    _selecterController.maxComment = null;
                  } else {
                    int? maxVal = int.tryParse(value);
                    if (maxVal != null && maxVal >= 0) {
                      _selecterController.maxComment = maxVal;
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  //创建取消和确定按钮的栏目
  Widget _buildCancelAndConfirmButton() {
    return Container(
      height: 150,
      width: 400,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.bottomCenter,
      child: buildCancelAndConfirmButton(
        () {
          // 取消操作，使用传入的context
          Navigator.of(context).pop();
        },
        () {
          // 确定操作，使用传入的context
          Navigator.of(context).pop();
          // 其他操作...
        },
        context: context, // 传入context
      ),
    );
  }
}
