import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:mobx/mobx.dart';

import 'package:tutoring_software/bean/widgets/widgets_builder.dart';
import 'package:tutoring_software/modules/account_manager/account_match.dart';
import 'package:tutoring_software/pages/chat/search/search_controller.dart'
    as custom;
import 'package:tutoring_software/bean/widgets/rating_input.dart';
import 'package:tutoring_software/modules/status/status_controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //引入搜索控制器
  final custom.SearchController _searchController =
      Modular.get<custom.SearchController>();
  //引入状态控制器来获取当前用户的信息
  final StatusController statusController = Modular.get<StatusController>();

  //文本控制器，uID的，电话号码的，邮箱的
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _userPhoneController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  //这三个属性的数字编码:其中，1为uID，2为手机号，3为邮箱
  int _userDataType = 0;

  //是否已经搜索
  bool isSearch = true;
  //是否打开评价页面
  bool isScore = false;

  // 存储reaction的disposer，使用控制器监视uID的变化来监听是否更新了用户
  ReactionDisposer? _searchReaction;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在首帧渲染后初始化
      _initializeController();
    });
  }

  void _initializeController() {
    try {
      // 设置reaction来监听搜索状态变化
      _searchReaction = reaction(
        // 监听一个包含isLogin和uID的列表，这样任何一个变化都会触发
        (_) => [_searchController.searchUid],
        (List value) {
          // 使用setState确保UI更新
          setState(() {
            // 当搜索后的用户ID变化时，来让搜索页面变为false
            isSearch = false;
            debugPrint('搜索后的用户ID已改变');
          });
        },
      );
    } catch (e) {
      debugPrint('初始化控制器失败: $e');
    }
  }

  //销毁对象
  @override
  void dispose() {
    super.dispose();
    _searchReaction?.reaction.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(title: Text('搜索用户')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isSearch
              ? [..._searchFrame(context)]
              : [
                  _buildBackButton(),
                  _buildUserInfo(),
                  //及联产开
                  if (isScore) ...[
                    _buildScoreTable(),
                    const SizedBox(height: 20),
                    _buildRatingInput(),
                  ],
                ],
        ),
      ),
    );
  }

  //添加搜索框架
  List<Widget> _searchFrame(BuildContext context) {
    List<Widget> list = [];
    //添加用户ID搜索框
    list.add(
      buildProperty(
        Container(
          margin: EdgeInsets.only(left: 50, right: 50, top: 10),
          child: TextField(
            keyboardType: TextInputType.number,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            controller: _userIDController,
            // autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              // 修改为圆角紫色边框
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              labelText: '用户ID',
              suffixIcon: IconButton(
                onPressed: () {
                  _userIDController.clear();
                },
                icon: const Icon(Icons.clear),
              ),
              // errorText: _isPasswordValid ? null : "你的密码格式不正确哟",
            ),
          ),
        ),
      ),
    );
    list.add(const SizedBox(height: 20));
    list.add(
      buildProperty(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            keyboardType: TextInputType.phone,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            controller: _userPhoneController,
            // autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone),
              // 修改为圆角紫色边框
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              labelText: '用户手机号',
              suffixIcon: IconButton(
                onPressed: () {
                  _userPhoneController.clear();
                },
                icon: const Icon(Icons.clear),
              ),
              // errorText: _isPasswordValid ? null : "你的密码格式不正确哟",
            ),
          ),
        ),
      ),
    );
    list.add(const SizedBox(height: 20));
    list.add(
      buildProperty(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            // inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
            controller: _userEmailController,
            // autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              // 修改为圆角紫色边框
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.purple, width: 2.0),
              ),
              labelText: '用户邮箱',
              suffixIcon: IconButton(
                onPressed: () {
                  _userEmailController.clear();
                },
                icon: const Icon(Icons.clear),
              ),
              // errorText: _isPasswordValid ? null : "你的密码格式不正确哟",
            ),
          ),
        ),
      ),
    );
    list.add(const SizedBox(height: 20));
    list.add(
      Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 200,
          height: 80,
          child: Column(
            children: [
              const Text("你只需要填写其中的任意一个", style: TextStyle(fontSize: 12)),
              OutlinedButton.icon(
                onPressed: () async => await _vaildateAccount(),
                icon: const Icon(Icons.app_registration),
                label: const Text('确定'),
              ),
            ],
          ),
        ),
      ),
    );
    return list;
  }

  //输入数据验证
  Future<void> _vaildateAccount() async {
    // 获取电话和邮箱输入值
    String phone = _userPhoneController.text.trim();
    String email = _userEmailController.text.trim();
    //获取UID的值
    String uid = _userIDController.text.trim();

    // 如果电话不为空，检查格式是否正确
    if (phone.isNotEmpty) {
      if (AccountMatch.isValidPhone(phone)) {
        _userDataType = 2;
        await _searchController.searchUidByPhone(phone);
        return;
      } else {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(const SnackBar(content: Text("电话格式输入错误")));
      }
    }
    // 如果邮箱不为空，检查格式是否正确
    if (email.isNotEmpty) {
      if (AccountMatch.isValidEmail(email)) {
        _userDataType = 1;
        await _searchController.searchUidByEmail(email);
        return;
      } else {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(const SnackBar(content: Text("邮箱格式输入错误")));
      }
    }
    //其中UID为数字组成的19位的字符串
    if (uid.isNotEmpty) {
      if (AccountMatch.isValidUid(uid)) {
        _userDataType = 0;
        await _searchController.searchUserDataItem(uid);
        return;
      } else {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(const SnackBar(content: Text("UID格式输入错误")));
      }
    }

    // 全部为空
    ScaffoldMessenger.of(
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(const SnackBar(content: Text("你什么都没有输入")));
  }

  /****接下来是搜索成功之后的用户显示页面，也就是isSearch = false的时候****/
  //这个是返回按钮，在页面顶端的左端
  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey[800]!),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: 140,
        height: 60,
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
            setState(() {
              isSearch = true;
              isScore = false;
              // 清空输入框
              _userIDController.clear();
              _userPhoneController.clear();
              _userEmailController.clear();
              // 重置搜索结果
            });
          },
        ),
      ),
    );
  }

  //还要有搜索出来的用户的介绍
  Widget _buildUserInfo() {
    return Center(
      child: SizedBox(
        width: 500,
        height: 250,
        child: GFCard(
          titlePosition: GFPosition.start,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(100, 0, 255, 0),
          title: GFListTile(
            avatar: GFAvatar(
              backgroundImage: AssetImage("lib/data/images/1.png"),
              radius: 20,
            ),
            title: Text(
              _searchController.searchUserData.uName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subTitle: Text(
              "联系方式: \n电话：${_searchController.searchUserData.uPhone}\n邮箱：${_searchController.searchUserData.uEmail}\nUID：${_searchController.searchUserData.uID}",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Colors.grey[800],
              ),
            ),
          ),
          buttonBar: GFButtonBar(
            children: <Widget>[
              GFButton(
                onPressed: () => setState(() => isScore = !isScore),
                text: "评价",
                shape: GFButtonShape.pills,
                borderSide: BorderSide(color: Colors.black),
                color: GFColors.TRANSPARENT,
                icon: Icon(MdiIcons.star, color: Colors.amberAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //评分表
  Widget _buildScoreTable() {
    final double ratio = _searchController.userRating.clamp(0.0, 5.0) / 5.0;
    return Center(
      child: Container(
        width: 270,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.amberAccent[200]!),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            //这个是零分按钮
            IconButton(
              onPressed: () =>
                  setState(() => _searchController.userRating = 0.0),
              icon: Icon(
                Icons.exposure_zero_outlined,
                color: _searchController.userRating == 0.0
                    ? Colors.red
                    : Colors.black,
              ),
            ),
            //这个是评分表
            GFRating(
              value: _searchController.userRating,
              size: GFSize.SMALL,
              color: Colors.amberAccent[200]!,
              borderColor: Colors.amberAccent[200]!, //当未选择的时候的颜色
              onChanged: (value) {
                setState(() {
                  // 将评分四舍五入到最接近的0.5，算了，直接变成整数吧
                  // _searchController.userRating = (value * 2).round() / 2;
                  _searchController.userRating = value.toInt().toDouble();
                  debugPrint("调整用户评分:${_searchController.userRating}");
                });
              },
            ),
            const SizedBox(width: 5),
            Text(
              _searchController.userRating.toStringAsFixed(0),
              style: _getRatingTextStyle(),
            ),
            const SizedBox(width: 5),
            Icon(
              [
                MdiIcons.emoticonCry,
                MdiIcons.emoticonFrown,
                MdiIcons.emoticonSad,
                MdiIcons.emoticonNeutral,
                MdiIcons.emoticonHappy,
                MdiIcons.emoticonExcited,
              ][(ratio * 5).round().clamp(0, 5)],
              color: Color.lerp(Colors.red, Colors.green, ratio)!,
            ),
          ],
        ),
      ),
    );
  }

  //根据评分动态生成文本样式
  TextStyle _getRatingTextStyle() {
    // 评分范围：0-5
    final double ratio = _searchController.userRating.clamp(0.0, 5.0) / 5.0;

    // 计算动态样式值
    final double fontSize = 12 + (18 - 12) * ratio;
    final FontWeight fontWeight = [
      FontWeight.w200,
      FontWeight.w300,
      FontWeight.w400,
      FontWeight.w500,
      FontWeight.w600,
      FontWeight.w700,
      FontWeight.w800,
    ][(ratio * 5).round().clamp(0, 5)];
    final Color color = Color.lerp(Colors.red, Colors.green, ratio)!;

    return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }

  //文本输入框，用来输入评价
  Widget _buildRatingInput() {
    return KeyedSubtree(
      key: ValueKey(_searchController.userRating), // 使用评分作为key，确保评分变化时重建组件
      child: RatingInput(
        userName: statusController.uName,
        initialRating: _searchController.userRating.toInt(),
        onSubmit: (comment, rating) {
          print("发布评价: $comment, 评分: $rating");
          // 这里可以添加发布评价的逻辑
        },
      ),
    );
  }
}
