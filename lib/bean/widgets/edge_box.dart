import "package:flutter/material.dart";

//制作一个只拥有外边距的容器，用于包裹其他组件
class EdgeBox extends StatelessWidget {
  const EdgeBox({
    super.key,
    required this.child,
    this.margin = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:margin,
      child:child
    );
  }
}
