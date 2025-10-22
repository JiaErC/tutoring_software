import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:flutter_material_design_icons/flutter_material_design_icons.dart";
import 'package:getwidget/getwidget.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  //判断是老师还是学生
  bool _isTeacher = true;
  //判断是否横屏
  bool _isLandscape = false;
  //判断两个下拉菜单是否展开
  bool _isPrimaryExpanded = false; //这个是中小学科目菜单
  bool _isSecondaryExpanded = false; //这个是大学生和成年人科目菜单

  //存储解析之后的JSON文件
  Map<String, dynamic>? _subjectData;
  String? _selectedCategory; //记录选中的学科大类

  @override
  void initState() {
    super.initState();
    _loadSubjectData();
  }

  Future<void> _loadSubjectData() async {
    try {
      // 从assets加载JSON文件
      String data = await rootBundle.loadString('lib/data/subjects_data.json');
      // 解析JSON
      setState(() {
        _subjectData = json.decode(data);
      });
    } catch (e) {
      debugPrint('加载科目数据出错: $e');
    }
  }

  //在didChangeDependencies()中获取路由参数
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在didChangeDependencies中获取路由参数
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _isTeacher = args?['isTeacher'] ?? true;
    // 如果参数改变需要更新UI，可以调用setState
    // setState(() {
    //   isTeacher = args?['isTeacher'] ?? true;
    // });
  }

  @override
  Widget build(BuildContext context) {
    _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: "返回上一页",
          onPressed: () => Navigator.pop(context), // 返回上一级路由
        ),
        title: _isTeacher ? const Text("选择教学科目") : const Text("选择学习科目"),
      ),
      backgroundColor: Colors.white,
      body: _isLandscape
          ? Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(flex: 2, child: _majorSubjectGroups(context)),
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                Expanded(flex: 1, child: _majorSubjectGroups(context)),
                Expanded(
                  flex: 2,
                  child: Container(color: Colors.lightBlue[50]),
                ),
              ],
            ),
    );
  }

  //封装按钮，横屏的时候的按钮和竖屏时候的按钮不一样
  Widget _buildButton(String s, IconData i) {
    return _isLandscape
        ? GFButton(
            onPressed: () => _selectedCategory = s,
            icon: Icon(i, size: 18),
            shape: GFButtonShape.square,
            fullWidthButton: true,
            text: s,
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            type: GFButtonType.transparent,
          )
        : SizedBox(
            height: 60,
            child: GFButton(
              onPressed: () => _selectedCategory = s,
              icon: Icon(i, size: 23), // 增加图标大小
              shape: GFButtonShape.square,
              fullWidthButton: true,
              text: s,
              textStyle: TextStyle(
                fontSize: 20, // 增加文字大小
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              type: GFButtonType.transparent,
              padding: EdgeInsets.all(12), // 添加内边距参数
            ),
          );
  }

  //以下为选择科目组件
  //大科目菜单
  Widget _majorSubjectGroups(BuildContext context) {
    //下拉菜单的文字样式
    TextStyle dropDownTextStyle = _isLandscape
        ? TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _isPrimaryExpanded ? Colors.purple[900] : Colors.black87,
          )
        : TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: _isPrimaryExpanded ? Colors.purple[900] : Colors.black87,
          );

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: AlwaysScrollableScrollPhysics(),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min, // 使Column只占用其子内容所需的空间
            crossAxisAlignment: CrossAxisAlignment.start, // 内容左对齐
            children: [
              // 使用ExpansionTile创建下拉菜单
              ExpansionTile(
                leading: const Icon(MdiIcons.tableChair),
                textColor: Colors.deepPurpleAccent,
                title: Text(
                  _isLandscape ? "小学和中学" : "小学\n中学",
                  style: dropDownTextStyle,
                ),
                subtitle: Text(
                  _isPrimaryExpanded ? "" : "适合中小学生未成年人，需要绑定家长",
                  style: TextStyle(fontSize: 10, color: Colors.black45),
                ),
                // 控制初始是否展开
                initiallyExpanded: _isPrimaryExpanded,
                //回调函数，获取是否展开
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _isPrimaryExpanded = expanded;
                  });
                },
                // 下拉菜单中的内容
                children: <Widget>[
                  const SizedBox(height: 10),
                  // 小学科目
                  _buildButton("小学科目", MdiIcons.pencil),
                  // 初中科目
                  _buildButton("初中科目", MdiIcons.pen),
                  // 高中科目
                  _buildButton("高中科目", MdiIcons.bookOpenBlankVariant),
                  //兴趣爱好
                  _buildButton("兴趣爱好", MdiIcons.heartPulse),
                  const SizedBox(height: 10),
                ],
              ),
              ExpansionTile(
                leading: const Icon(MdiIcons.accountSchool),
                title: Text("大学学习\n终身学习", style: dropDownTextStyle),
                subtitle: Text(
                  _isSecondaryExpanded ? "" : "适合成年人，不需要绑定家长",
                  style: TextStyle(fontSize: 10, color: Colors.black45),
                ),
                // 控制初始是否展开
                initiallyExpanded: _isSecondaryExpanded,
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _isSecondaryExpanded = expanded;
                  });
                },
                // 下拉菜单中的内容
                children: <Widget>[
                  const SizedBox(height: 10),
                  _buildButton("理科数学物理", MdiIcons.bookOpenVariant),
                  _buildButton("IT互联网", MdiIcons.wifi),
                  _buildButton("健康和锻炼", MdiIcons.dumbbell),
                  _buildButton("外语学习", MdiIcons.abTesting),
                  _buildButton("设计与艺术", MdiIcons.palette),
                  _buildButton("工学技能", MdiIcons.wrench),
                  _buildButton("商业管理", MdiIcons.briefcase),
                  _buildButton("历史与文化", MdiIcons.bookOpen),
                  _buildButton("环境科学", MdiIcons.leaf),
                  _buildButton("创业与创新", MdiIcons.lightbulb),
                  _buildButton("个人成长", MdiIcons.heart),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //小科目菜单
  //打包Warp流式显示表格
  Widget _wrapSubjects(BuildContext context){
  if(_subjectData != null && _selectedCategory !=null){
    Map<String, dynamic> subMap = _subjectData!["兴趣爱好"];


  }
    return Container();
  }

//参考代码
//   if (_subjectData != null && _selectedCategory == "兴趣爱好") {
//   // 获取兴趣爱好Map
//   Map<String, dynamic> hobbyMap = _subjectData!["兴趣爱好"];
  
//   // 遍历所有子类别
//   hobbyMap.forEach((String subCategory, dynamic subjects) {
//     // subCategory: "美术类"、"音乐类"等
//     // 将subjects转换为String列表
//     List<String> subjectList = (subjects as List).cast<String>();
    
//     debugPrint("子类别: $subCategory, 科目数量: ${subjectList.length}");
//   });
// }

  //对应的组件
  Widget _subfieldSubjects(BuildContext context) {
    return Container();
  }
}
