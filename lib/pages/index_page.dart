import 'package:flutter/material.dart';
import 'package:tutoring_software/pages/menu/menu.dart';

//再者各路由中的加载导航栏
class IndexPage extends StatefulWidget {
  //const IndexPage({super.key});
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with  WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    return const ScaffoldMenu();
  }
}
