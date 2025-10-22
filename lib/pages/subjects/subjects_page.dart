import 'package:flutter/material.dart';
import "package:flutter_material_design_icons/flutter_material_design_icons.dart";
import 'package:getwidget/getwidget.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  //判断是老师还是学生
  bool isTeacher = true;

  //在didChangeDependencies()中获取路由参数
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在didChangeDependencies中获取路由参数
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    isTeacher = args?['isTeacher'] ?? true;
    // 如果参数改变需要更新UI，可以调用setState
    // setState(() {
    //   isTeacher = args?['isTeacher'] ?? true;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: "返回上一页",
          onPressed: () => Navigator.pop(context), // 返回上一级路由
        ),
        title: isTeacher ? const Text("选择教学科目") : const Text("选择学习科目"),
      ),
      backgroundColor: Colors.white,
      body: MediaQuery.of(context).orientation == Orientation.landscape
          ? Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 1000,
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Container(color: Colors.red)),
                    Expanded(flex: 1, child: _majorSubjectGroups(context)),
                    Expanded(flex: 2, child: Container(color: Colors.blue)),
                  ],
                ),
              ),
            )
          : Row(
              children: [
                Expanded(flex: 1, child: Container(color: Colors.red)),
                Expanded(flex: 1, child: _majorSubjectGroups(context)),
                Expanded(flex: 1, child: Container(color: Colors.blue)),
              ],
            ),
    );
  }

  //以下为选择科目组件
  //大科目菜单
  Widget _majorSubjectGroups(BuildContext context) {
    return SingleChildScrollView(
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
              title: const Text(
                "小学和中学",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 25, 27, 31),
                ),
              ),
              // 控制初始是否展开
              initiallyExpanded: false,
              // 下拉菜单中的内容
              children: [
                const SizedBox(height: 10),
                // 小学科目
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GFButton(
                    onPressed: () => debugPrint("选择小学科目"),
                    icon: Icon(MdiIcons.pencil, size: 16),
                    shape: GFButtonShape.square,
                    fullWidthButton: true,
                    text: "小学科目",
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    type: GFButtonType.transparent,
                  ),
                ),
                // 初中科目
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GFButton(
                    onPressed: () => debugPrint("选择高中科目"),
                    icon: Icon(MdiIcons.pen, size: 16),
                    shape: GFButtonShape.square,
                    fullWidthButton: true,
                    text: "初中科目",
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    type: GFButtonType.transparent,
                  ),
                ),
                // 高中科目
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GFButton(
                    onPressed: () => debugPrint("选择高中科目"),
                    icon: Icon(MdiIcons.bookOpenBlankVariant, size: 16),
                    fullWidthButton: true,
                    shape: GFButtonShape.square,
                    text: "高中科目",
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    type: GFButtonType.transparent,
                  ),
                ),
                // 兴趣爱好
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GFButton(
                    onPressed: () => debugPrint("选择兴趣爱好"),
                    icon: Icon(MdiIcons.music, size: 16),
                    shape: GFButtonShape.square,
                    fullWidthButton: true,
                    text: "兴趣爱好",
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    type: GFButtonType.transparent,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            ExpansionTile(
              title: const Text(
                "大学学习\n终身学习",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 25, 27, 31),
                ),
              ),
              // 控制初始是否展开
              initiallyExpanded: false,
              // 下拉菜单中的内容
              children: [
                const SizedBox(height: 10),
                GFButton(
                  onPressed: () => debugPrint("选择理科数学物理"),
                  icon: Icon(MdiIcons.calculator, size: 16),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  text: "理科数学物理",
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  type: GFButtonType.transparent,
                ),
                GFButton(
                  onPressed: () => debugPrint("选择IT互联网"),
                  icon: Icon(MdiIcons.wifi, size: 16),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  text: "IT互联网",
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  type: GFButtonType.transparent,
                ),
                GFButton(
                  onPressed: () => debugPrint("选择健康和锻炼"),
                  icon: Icon(MdiIcons.dumbbell, size: 16),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  text: "健康和锻炼",
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  type: GFButtonType.transparent,
                ),
                GFButton(
                  onPressed: () => debugPrint("选择外语学习"),
                  icon: Icon(Icons.abc_sharp, size: 16),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  text: "外语学习",
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  type: GFButtonType.transparent,
                ),
                GFButton(
                  onPressed: () => debugPrint("选择设计和艺术"),
                  icon: Icon(MdiIcons.palette, size: 16),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  text: "设计与艺术",
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  type: GFButtonType.transparent,
                ),
                GFButton(
                  onPressed: () => debugPrint("选择工学技能"),
                  icon: Icon(MdiIcons.wrench, size: 16),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  text: "工学技能",
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  type: GFButtonType.transparent,
                ),
                GFButton(
                  onPressed: () => debugPrint("选择商业管理"),
                  icon: Icon(MdiIcons.briefcase, size: 16),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  text: "商业管理",
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  type: GFButtonType.transparent,
                ),
                GFButton(
                  onPressed: () => debugPrint("选择心理学与教育"),
                  icon: Icon(MdiIcons.brain, size: 16),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  text: "心理学与教育",
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  type: GFButtonType.transparent,
                ),
                GFButton(
                  onPressed: () => debugPrint("选择历史与文化"),
                  icon: Icon(MdiIcons.bookOpen, size: 16),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  text: "历史与文化",
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  type: GFButtonType.transparent,
                ),
                GFButton(
                  onPressed: () => debugPrint("选择环境科学"),
                  icon: Icon(MdiIcons.leaf, size: 16),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  text: "环境科学",
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  type: GFButtonType.transparent,
                ),
                GFButton(
                  onPressed: () => debugPrint("选择创业与创新"),
                  icon: Icon(MdiIcons.lightbulb, size: 16),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  text: "创业与创新",
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  type: GFButtonType.transparent,
                ),
                GFButton(
                  onPressed: () => debugPrint("选择个人成长"),
                  icon: Icon(MdiIcons.heart, size: 16),
                  shape: GFButtonShape.square,
                  fullWidthButton: true,
                  text: "个人成长",
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  type: GFButtonType.transparent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
