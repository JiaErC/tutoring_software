// 添加所需的导入
import 'package:flutter/material.dart' hide SearchController;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:tutoring_software/pages/chat/search/search_controller.dart';

// 评价输入组件
class RatingInput extends StatefulWidget {
  // 用户信息
  final String userName;
  final int initialRating; // 初始评分
  // 发布回调
  final Function(String comment, int rating) onSubmit;
  // 用户头像
  final ImageProvider<Object> avatarProvider;
  //是否选择科目按钮
  final bool isShowSelectSubjectButton;

  const RatingInput({
    super.key,
    required this.userName,
    this.initialRating = 5,
    required this.onSubmit,
    //需要图片
    required this.avatarProvider,
    //是否显示选择科目按钮
    this.isShowSelectSubjectButton = false,
  });

  @override
  _RatingInputState createState() => _RatingInputState();
}

class _RatingInputState extends State<RatingInput> {
  // 评分状态
  int _rating = 5;
  // 评论内容
  TextEditingController _commentController = TextEditingController();

  //搜索控制器
  final SearchController _searchController = Modular.get<SearchController>();

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  // 添加此方法来监听widget属性变化
  @override
  void didUpdateWidget(covariant RatingInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当外部传入的initialRating发生变化时，更新内部评分
    if (oldWidget.initialRating != widget.initialRating) {
      setState(() {
        _rating = widget.initialRating;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  //文字边框的颜色设置
  Color _getRoleColor() {
    return Colors.red.shade600;
  }

  //背景的颜色设置
  Color _getBackgroundColor() {
    return Colors.red.shade100;
  }

  @override
  Widget build(BuildContext context) {
    //引入搜索控制器

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部信息栏
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // 用户头像
                    CircleAvatar(
                      backgroundImage: widget.avatarProvider,
                      radius: 20,
                      // 如果网络图片加载失败，显示默认头像
                      backgroundColor: Colors.grey,
                      // child: widget.userAvatarUrl.isEmpty
                      //     ? Text(widget.userName.substring(0, 1))
                      //     : null,
                    ),
                    SizedBox(width: 12),
                    // 用户名
                    Text(
                      widget.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(width: 30),
                    // 选择科目按钮
                    if (widget.isShowSelectSubjectButton)
                      _buildSelectSubjectButton(),
                  ],
                ),
                Row(
                  children: [
                    // 评分星星
                    GFRating(
                      value: _rating.toDouble(),
                      size: GFSize.SMALL,
                      color: Colors.amberAccent[200]!,
                      borderColor: Colors.amberAccent[200]!, //当未选择的时候的颜色
                      onChanged: (_) {},
                    ),
                    SizedBox(width: 8),
                    // 评价图标
                    Icon(
                      FontAwesomeIcons.comment,
                      color: Colors.blue.shade700,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 文本输入区域
          Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "请输入您的评价...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLength: 300,
                  maxLines: null, // 允许无限多行
                  minLines: 1, // 初始一行
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
                // 右下角的发布按钮
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_commentController.text.trim().isNotEmpty) {
                          widget.onSubmit(
                            _commentController.text.trim(),
                            _rating,
                          );
                          _commentController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade200, // 淡蓝色背景
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "发布",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 实现科目选择按钮
  Widget _buildSelectSubjectButton() {
    return ElevatedButton(
      onPressed: _showSubjectsMenu,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade300,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        "选择科目",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  //展示这个老师有什么科目可以选择
  void _showSubjectsMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许底部菜单占满更多空间
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, // 适配键盘
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '选择科目',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildSubjects(),
                const SizedBox(height: 20),
                // 添加取消和确定按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          // 取消操作，返回到上一个路由
                          Navigator.of(context).pop();
                        },
                        child: Text('取消'),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 确定操作，返回到上一个路由
                          Navigator.of(context).pop();
                        },
                        child: Text('确定'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
      // 设置菜单样式
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      // 启用可拖动关闭
      enableDrag: true,
    );
  }

  //接下来制作显示搜索出来的老师的各个学科
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
    _searchController.searchUserData.uTeachSubjects.forEach((
      bigSubject,
      smallSubjects,
    ) {
      list.add(
        Observer(
          builder: (_) {
            bool isExpanded =
                _searchController.isViewSubjects[bigSubject] ?? true;
            debugPrint("rating_input.dart 当前展开状态：$isExpanded");

            return Column(
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
                        SizedBox(width: 8),
                        // 使用AnimatedSwitcher确保图标正确动画切换
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 200),
                          child: Icon(
                            isExpanded
                                ? Icons.arrow_drop_down
                                : Icons.arrow_right,
                            key: ValueKey<bool>(isExpanded),
                            color: _getRoleColor(),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      // 只调用switchViewSubjects，不读取状态
                      _searchController.switchViewSubjects(bigSubject);
                    },
                  ),
                ),
                // 使用AnimatedSwitcher确保内容正确显示/隐藏
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  child: isExpanded
                      ? Column(
                          key: ValueKey('expanded_$bigSubject'),
                          children: _buildSmallSubjects(smallSubjects),
                        )
                      : SizedBox.shrink(),
                ),
              ],
            );
          },
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
    ss.forEach((s) {
      list.add(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            bool isSelected =
                _searchController.selectedTeachSubjectsMap[s] ??
                false; // 用于跟踪当前按钮是否被选中
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
                    _searchController.changeSelectedSubjects(s);
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
}
