import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //用来定义目前处于的是哪一个聊天界面，是寻找界面还是朋友界面
  bool isFind = true;

  //是否打开搜索界面

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  buildBackButton(),
                  buildFilterButton(),
                  buildChatButton(),
                  buildSearchButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //构建一个搜索用户的按钮
  Widget buildSearchButton() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(left: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.green[200],
          border: Border.all(color: Colors.green[800]!),
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextButton(
          child: Row(
            children: [
              Text(
                "搜索",
                style: TextStyle(
                  color: Colors.green[800]!,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 8), // 文本和图标之间的间距
              Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.green[800]!,
                size: 30,
              ),
            ],
          ),
          onPressed: () {
            Modular.to.pushNamed("/tab/chat/search");
            debugPrint("搜索");
          },
        ),
      ),
    );
  }

  //这里是寻找老师学生，好友交谈切换
  Widget buildChatButton() {
    return Expanded(
      flex: 1,
      child: Tooltip(
        message: isFind ? "切换到我的好友" : "切换到寻找老师或学生",
        child: AnimatedContainer(
          margin: EdgeInsets.only(left: 10),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isFind ? Colors.grey[200] : Colors.greenAccent[100],
            border: Border.all(
              color: isFind ? Colors.grey[800]! : Colors.greenAccent[700]!,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextButton(
            child: Row(
              children: [
                Text(
                  isFind ? "寻找" : "好友",
                  style: TextStyle(
                    color: isFind
                        ? Colors.grey[800]!
                        : Colors.greenAccent[700]!,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 8), // 文本和图标之间的间距
                Icon(
                  Icons.swap_horiz,
                  color: isFind ? Colors.grey[800]! : Colors.greenAccent[700]!,
                  size: 30,
                ),
              ],
            ),
            onPressed: () {
              setState(() {
                isFind = !isFind;
              });
              debugPrint(isFind ? "寻找老师或学生" : "我的好友");
            },
          ),
        ),
      ),
    );
  }

  //返回按钮
  Widget buildBackButton() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey[800]!),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: TextButton(
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_rounded,
                color: Colors.grey[800]!,
                size: 30,
              ),
              SizedBox(width: 8), // 图标和文本之间的间距
              Text(
                "返回",
                style: TextStyle(
                  color: Colors.grey[800]!,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          onPressed: () {
            Modular.to.pushNamed("/tab/home/");
          },
        ),
      ),
    );
  }

  //筛选按钮，可以进入到筛选界面
  Widget buildFilterButton() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.red[200],
          border: Border.all(color: Colors.red[800]!),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Tooltip(
          message: "筛选老师或者学生",
          child: TextButton(
            child: Row(
              children: [
                Icon(
                  Icons.filter_alt_rounded,
                  color: Colors.red[800]!,
                  size: 30,
                ),
                Text(
                  "筛选",
                  style: TextStyle(
                    color: Colors.red[800]!,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            onPressed: () {
              debugPrint("筛选老师或者学生");
            },
          ),
        ),
      ),
    );
  }
}
