// 添加所需的导入
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';

// 评价输入组件
class RatingInput extends StatefulWidget {
  // 用户信息
  final String userName;
  final int initialRating; // 初始评分
  // 发布回调
  final Function(String comment, int rating) onSubmit;

  const RatingInput({
    Key? key,
    required this.userName,
    this.initialRating = 5,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _RatingInputState createState() => _RatingInputState();
}

class _RatingInputState extends State<RatingInput> {
  // 评分状态
  int _rating = 5;
  // 评论内容
  TextEditingController _commentController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
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
                      backgroundImage: AssetImage('lib/data/images/1.png'),
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
}
