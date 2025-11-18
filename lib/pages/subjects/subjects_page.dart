import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:flutter_material_design_icons/flutter_material_design_icons.dart";
import 'package:getwidget/getwidget.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tutoring_software/pages/subjects/subjects_controller.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  //引入学科页面控制类来监视持久化信息
  final SubjectsController _subjectsController =
      Modular.get<SubjectsController>();

  //判断是老师还是学生
  bool _isTeacher = true;
  //判断是否横屏
  bool _isLandscape = false;
  //判断两个下拉菜单是否展开
  bool _isPrimaryExpanded = false; //这个是中小学科目菜单
  bool _isSecondaryExpanded = false; //这个是大学生和成年人科目菜单
  //是否查看
  bool _isView = false;

  //存储选择科目的多少
  int _count = 0;
  //各个学科大类有多少科目被选择
  final Map<String, int> _subjectSelectedCounts = {};

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
    // //在这里获取注册控制类的信息
    // _selectedSubjects = _isTeacher
    //     ? _registerController.uTeachSubjects
    //     : _registerController.uStudySubjects;
    // //获取选择的学科数量
    // _count = _isTeacher
    //     ? _registerController.uTeachSubjectsCount
    //     : _registerController.uStudySubjectsCount;
    //     // 从subjectsController获取数据而不是registerController
    _selectedSubjects = _isTeacher
        ? _subjectsController.teachSubjects
        : _subjectsController.studySubjects;

    _count = _isTeacher
        ? _subjectsController.teachSubjectsCount
        : _subjectsController.studySubjectsCount;
    //获取选择的学科具体数量
    _calculateSubjectCounts();
  }

  //计算每个学科大类的科目被选择总数
  void _calculateSubjectCounts() {
    _subjectSelectedCounts.clear();
    if (_selectedSubjects.isNotEmpty) {
      _selectedSubjects.forEach((category, subcategories) {
        int selectedCount = 0;
        // 遍历每个大类下的所有小类
        subcategories.forEach((subcategory, subjects) {
          if (subjects is List) {
            // 累加这个小类下已选择的科目数量
            selectedCount += subjects.length;
          }
        });
        // 存储这个大类下已选择的科目数量
        _subjectSelectedCounts[category] = selectedCount;
      });
    }
  }

  //创建一个按钮构建器，用来构建这个页面需要的控制按钮
  Widget _buildControlButton(String s, Color c, Function() f) {
    return GFButton(
      text: s,
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
      color: c,
      onPressed: f,
    );
  }

  @override
  Widget build(BuildContext context) {
    _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: GFAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: "返回上一页",
          onPressed: () {
            // _isTeacher
            //     ? _registerController.uTeachSubjects = _selectedSubjects
            //     : _registerController.uStudySubjects = _selectedSubjects;
            // // 更新选择的学科数量
            // _isTeacher
            //     ? _registerController.uTeachSubjectsCount = _count
            //     : _registerController.uStudySubjectsCount = _count;
            // 不需要保存到subjectsController
            // _isTeacher
            //     ? _subjectsController.updateTeachSubjects(_selectedSubjects)
            //     : _subjectsController.updateStudySubjects(_selectedSubjects);
            Navigator.pop(context);
          }, // 返回上一级路由
        ),
        title: _isTeacher ? const Text("选择教学科目") : const Text("选择学习科目"),
        actions: <Widget>[
          //存放一个下拉菜单，用来存放已经选择的学科
          //存放一个按钮，用来清除已选的学科
          _buildControlButton(
            "一键清空",
            Colors.redAccent,
            () => setState(() {
              _selectedSubjects.clear();
              _count = 0;
              _isView = false;
            }),
          ),
        ],
      ),
      floatingActionButton: _isView
          ? _buildControlButton(
              "返回",
              Colors.green,
              () => setState(() => _isView = false),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none, // 重要：允许角标溢出父容器
                    children: [
                      _buildControlButton(
                        "查看",
                        const Color.fromRGBO(251, 192, 45, 1),
                        () => setState(() => _isView = true),
                      ),
                      // 使用 Positioned 精确定位角标
                      Positioned(
                        top: -2, // 向上偏移，使其部分在按钮外部
                        right: -7, // 向右偏移
                        child: GFBadge(
                          color: Colors.redAccent,
                          shape: GFBadgeShape.circle,
                          size: 40,
                          child: Text(_count.toString()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  _buildControlButton("确认", Colors.blueAccent, () {
                    // _isTeacher
                    //     ? _registerController.uTeachSubjects = _selectedSubjects
                    //     : _registerController.uStudySubjects =
                    //           _selectedSubjects;
                    // //更新学科选择数量
                    // _isTeacher
                    //     ? _registerController.uTeachSubjectsCount = _count
                    //     : _registerController.uStudySubjectsCount = _count;
                    // 保存到subjectsController
                    _isTeacher
                        ? _subjectsController.updateTeachSubjects(
                            _selectedSubjects,
                          )
                        : _subjectsController.updateStudySubjects(
                            _selectedSubjects,
                          );
                    Navigator.pop(context);
                  }),
                ],
              ),
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
                      child: _isView
                          ? _viewSubjects(context)
                          : _subfieldSubjects(context),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlue[50],
                    ),
                    child: _isView
                        ? _viewSubjects(context)
                        : _subfieldSubjects(context),
                  ),
                ),
              ],
            ),
    );
  }

  //封装按钮，横屏的时候的按钮和竖屏时候的按钮不一样
  Widget _buildButton(String s, IconData i) {
    //当前类别已选择数量
    int categoryCount = _subjectSelectedCounts.containsKey(s)
        ? _subjectSelectedCounts[s]!
        : 0;

    // 统一使用Stack布局的按钮内容
    Widget buttonContent = Stack(
      clipBehavior: Clip.none, // 允许内容溢出
      children: [
        // 主要按钮内容
        Icon(i, size: _isLandscape ? 18 : 23),
        // 徽章（如果有数量）
        if (categoryCount > 0)
          Positioned(
            top: -7,
            right: -17,
            child: GFBadge(
              color: Colors.redAccent,
              shape: GFBadgeShape.circle,
              size: 40,
              child: Text(categoryCount.toString()),
            ),
          ),
      ],
    );

    return _isLandscape
        ? GFButtonBadge(
            onPressed: () {
              setState(() {
                _selectedCategory = s;
                debugPrint("$_subjectSelectedCounts");
              });
            },
            icon: buttonContent,
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
            child: GFButtonBadge(
              onPressed: () {
                setState(() {
                  _selectedCategory = s;
                  debugPrint("$_subjectSelectedCounts");
                });
              },
              icon: buttonContent, // 增加图标大小
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
    //判断按钮是否被选中
    bool isSelected = false;
    if (_selectedCategory != null &&
        _selectedSubjects.containsKey(_selectedCategory) &&
        _selectedSubjects[_selectedCategory]!.containsKey(subject) &&
        _selectedSubjects[_selectedCategory]![subject].contains(s)) {
      isSelected = true;
    }
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
            _count++;
            debugPrint("select $subject$s");
          } else {
            //如果不包含s，就添加
            if (!_selectedSubjects[_selectedCategory]![subject].contains(s)) {
              _selectedSubjects[_selectedCategory]![subject].add(s);
              _count++;
              debugPrint("select $subject$s");
            } //否则删除
            else {
              _removeSubject(_selectedCategory!, subject, s);
            }
          }
          //同时计算科目
          _calculateSubjectCounts();
        });
      },
      text: s,
      textStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      color: isSelected
          ? Colors.grey
          : Color.fromARGB(255, 0x64, 0xb5, 0xf5), //ff64b5f5
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
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                spacing: 7.5,
                runSpacing: 5.0,
                textDirection: TextDirection.ltr,
                children: w,
              ),
            ],
          ),
        );
      });
      expansionTileList.add(const SizedBox(height: 100));
    }
    return expansionTileList;
  }

  //对应的组件
  Widget _subfieldSubjects(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(children: _expansionTileSubjects()),
      ),
    );
  }

  //构建查看学科界面的每个学科的按钮
  Widget _buildViewButton(String s, Color c, Function() f) {
    return Container(
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            s,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          GFIconButton(
            icon: Icon(Icons.clear, color: Colors.black),
            shape: GFIconButtonShape.pills,
            type: GFButtonType.transparent,
            onPressed: f,
          ),
        ],
      ),
    );
  }

  //移除学科大类
  void _removeCategory(String category) {
    setState(() {
      _selectedSubjects.remove(category);
    });
  }

  //移除学科小类
  void _removeSubCategory(String category, String subCategory) {
    setState(() {
      _selectedSubjects[category]!.remove(subCategory);
      if (_selectedSubjects[category]!.isEmpty) {
        _removeCategory(category);
      }
    });
  }

  //移除具体的学科
  void _removeSubject(String category, String subCategory, String subject) {
    setState(() {
      _selectedSubjects[category]![subCategory]!.remove(subject);
      if (_selectedSubjects[category]![subCategory]!.isEmpty) {
        _removeSubCategory(category, subCategory);
        _count--;
      }
    });
  }

  // //构建查看三个学科的组件
  List<Widget> _viewSubjectsWidgets() {
    List<Widget> sizedBox = [const SizedBox(height: 10)];
    if (_selectedSubjects.isNotEmpty) {
      _selectedSubjects.forEach((categroy, subCategory) {
        List<Widget> childSubjects = [];
        subCategory.forEach((s, subList) {
          // 具体的学科
          List<Widget> subjectWidgets = [];
          for (String subject in subList) {
            subjectWidgets.add(
              _buildViewButton(
                subject,
                Colors.blueAccent,
                () => _removeSubject(categroy, s, subject),
              ),
            );
          }
          childSubjects.addAll([
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5.0,
              children: [
                const SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: _buildViewButton(
                    s,
                    Colors.blueAccent[400]!,
                    () => _removeSubCategory(categroy, s),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(spacing: 2.0, children: subjectWidgets),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),
          ]);
        });
        sizedBox.addAll([
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: _buildViewButton(
                    categroy,
                    Colors.blueAccent[700]!,
                    () => _removeCategory(categroy),
                  ),
                ),
                Expanded(flex: 2, child: Column(children: childSubjects)),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
            color: Color.fromARGB(255, 66, 165, 245),
            indent: 20,
            endIndent: 10,
          ),
        ]);
      });
    } else {
      setState(() => _isView = false);
    }
    sizedBox.add(const SizedBox(height: 100));
    return sizedBox;
  }

  //查看自己选择的学科的一个页面
  Widget _viewSubjects(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(children: _viewSubjectsWidgets()),
      ),
    );
  }
}
