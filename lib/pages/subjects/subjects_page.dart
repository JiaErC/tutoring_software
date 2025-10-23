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
  //存储选择的学科
  Map<String, dynamic> _selectedSubjects = {};

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
      appBar: GFAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: "返回上一页",
          onPressed: () => Navigator.pop(context), // 返回上一级路由
        ),
        title: _isTeacher ? const Text("选择教学科目") : const Text("选择学习科目"),
        actions: <Widget>[
          //存放一个下拉菜单，用来存放已经选择的学科
          //存放一个按钮，用来清除已选的学科
          GFButton(
            onPressed: () => debugPrint("已选的学科$_selectedSubjects"),
            icon: Icon(Icons.clear, size: 20),
            text: "清空已选数据",
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            shape: GFButtonShape.square,
            color: Colors.redAccent,
          ),
        ],
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
                      child: _subfieldSubjects(context),
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
                  child: Container(
                    color: Colors.lightBlue[50],
                    child: _subfieldSubjects(context),
                  ),
                ),
              ],
            ),
    );
  }

  //封装按钮，横屏的时候的按钮和竖屏时候的按钮不一样
  Widget _buildButton(String s, IconData i) {
    return _isLandscape
        ? GFButton(
            onPressed: () {
              setState(() {
                _selectedCategory = s;
                debugPrint(_selectedCategory);
              });
            },
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
              onPressed: () {
                setState(() {
                  _selectedCategory = s;
                  debugPrint(_selectedCategory);
                });
              },
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
  //制作小科目按钮
  Widget _buildSubButton(String s, String subject) {
    return GFButton(
      onPressed: () {
        if (_selectedCategory == null) {
          debugPrint("Fuck select $_selectedCategory");
        }
        setState(() {
          // 添加setState来更新UI
          // 如果_selectedSubjects中不存在_selectedCategory键，先创建一个空Map
          if (!_selectedSubjects.containsKey(_selectedCategory)) {
            _selectedSubjects[_selectedCategory!] = {};
          }
          // 然后安全地操作内部Map
          if (!_selectedSubjects[_selectedCategory]!.containsKey(subject)) {
            _selectedSubjects[_selectedCategory]![subject] = [s];
            debugPrint("Fuck select $subject$s");
          } else {
            _selectedSubjects[_selectedCategory]![subject].add(s);
            debugPrint("Fuck select $subject$s");
          }
        });
      },
      text: s,
      type: GFButtonType.outline,
      shape: GFButtonShape.square,
    );
  }

  //打包Warp流式显示表格
  List<Widget> _expansionTileSubjects() {
    List<Widget> expansionTileList = [];
    if (_subjectData != null && _selectedCategory != null) {
      Map<String, dynamic> subMap = _subjectData![_selectedCategory!];
      subMap.forEach((String subCategory, dynamic subjects) {
        //一个存放科目按钮的组件，用来当Wrap的子组件
        List<Widget> w = [];
        List<String> subList = (subMap[subCategory] as List).cast<String>();
        for (String s in subList) {
          w.add(_buildSubButton(s, subCategory));
        }
        expansionTileList.add(
          ExpansionTile(
            title: Text(subCategory),
            initiallyExpanded: true,
            children: [
              Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                textDirection: TextDirection.ltr,
                children: w,
              ),
            ],
          ),
        );
      });
    }
    return expansionTileList;
  }

  //对应的组件
  Widget _subfieldSubjects(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(children: _expansionTileSubjects()),
      ),
    );
  }

  //构建已经选择的学科的组件
  //存储下拉菜单项目的单个组件

  Widget _buildSelectedSubjects(BuildContext context) {
    return GFDropdown(
      onChanged: (value) {
        debugPrint("选择了学科:$value");
      },
      items: <DropdownMenuItem>[
        DropdownMenuItem(child: const Center(child: Text("选择学科"))),
      ],
    );
  }
}
