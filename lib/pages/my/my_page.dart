/*
PiliPlus分析
核心功能
构建页面UI骨架

使用Column作为根布局容器，实现垂直方向的组件排列
包含顶部操作栏、用户信息区、功能区和收藏区等主要模块
响应式状态管理

通过Obx组件监听控制器中的响应式数据变化（如用户信息、加载状态等）
当数据更新时，自动重新渲染相关UI组件
用户交互实现

集成下拉刷新功能(refreshIndicator)，触发controller.onRefresh方法
为各个可点击元素（如头像、按钮等）绑定相应的回调函数
页面结构详解
顶部操作栏(_buildHeaderActions)

包含搜索、无痕模式切换、账号模式切换、主题切换、设置等操作按钮
按钮根据条件动态显示（如非首页时显示搜索按钮）
用户信息区(_buildUserInfo)

显示用户头像、用户名、会员状态
展示硬币数量、经验值和经验条
提供统计数据（动态、关注、粉丝数量）
头像区域点击触发登录功能(controller.onLogin)
功能操作区(_buildActions)

根据控制器中的list动态生成快捷操作按钮
每个按钮包含图标和文字标签
收藏夹区域(_buildFav)

显示收藏夹入口和数量
根据加载状态显示不同UI（加载中、加载成功、加载失败）
加载成功时水平滚动展示收藏夹列表
技术实现特点
混入AutomaticKeepAliveClientMixin确保页面切换时保持状态
使用Material设计风格的组件和布局
主题适配通过Theme.of(context)获取当前主题并应用到UI元素
列表滚动优化使用ListView配合AlwaysScrollableScrollPhysics确保良好的滚动体验
加载状态管理通过switch语句处理不同的加载状态（Loading、Success、Error）
这个build方法是典型的Flutter声明式UI构建方式，通过组合不同的Widget和状态管理，创建出功能完整的个人中心页面。
*/

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(children: [userAvatar(context),settingButton(context)]),
        ],
      ),
    );
  }

  Widget userAvatar(context) {
    return Expanded(
      flex: 1,
      child: GFCard(
        titlePosition: GFPosition.start,
        color: Colors.transparent,
        elevation: 0,
        title: GFListTile(
          avatar: GFAvatar(
            backgroundImage: AssetImage("lib/data/images/1.png"),
            radius: 20,
          ),
          titleText: "请先登录",
          subTitleText: "这里是联系方式",
        ),
        content: Text("这里是简介"),
        //buttonBar:这里存放标签和联系方式
      ),
    );
  }

  //相关的设置按钮区域
  Widget settingButton(context) {
    return Expanded(
      flex: 1,
      child: GFButtonBar(
        children: [
          GFButton(
            text: "设置",
            onPressed: () {
              debugPrint("点击设置应用");
            },
          ),
        ],
      ),
    );
  }
}
