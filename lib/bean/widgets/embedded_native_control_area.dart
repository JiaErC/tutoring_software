/* 本文件代码复用来自Kazumi项目*/

import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:kazumi/utils/storage.dart';

//相较于StatefulWidget，增加了对平台特定边距的计算
class EmbeddedNativeControlArea extends StatefulWidget {
  /// The widget won't draw anything, just a placeholder for native window control.
  /// It only works on macOS at the moment.
  /// windows and linux have no way to embed native window control into flutter view.
  const EmbeddedNativeControlArea({
    super.key,//用于Flutter元素树的标识
    required this.child,//嵌入这个容器的子组件
    this.requireOffset = true,//可选参数默认为true，表示是否需要为原生窗口空间留出偏移量
  });

  final Widget child;
  final bool requireOffset;

  @override
  State<StatefulWidget> createState() => _EmbeddedNativeControlAreaState();
}

class _EmbeddedNativeControlAreaState extends State<EmbeddedNativeControlArea> {
  // bool showWindowButton =//控制窗口按钮的设置项，从应用的设置存储中获取
  //     GStorage.setting.get(SettingBoxKey.showWindowButton, defaultValue: false);
//仅仅在组件的内部使用，控制是否需要应用边框

  //返回组件需要用到的内边距信息
  EdgeInsets get getInsets {
    // if (!showWindowButton) {
    //   return EdgeInsets.zero;
    // }
    if (!widget.requireOffset) {
      return EdgeInsets.zero;
    }
    if (Platform.isMacOS) {
      return const EdgeInsets.only(top: 22);
    } else {
      return EdgeInsets.zero;
    }
  }

  //构建组件的UI界面
  //使用Padding组件根据getInsets属性为子组件添加内边距
  //在Flutter框架渲染组件的时候自动调用
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getInsets,
      child: widget.child,
    );
  }
}
