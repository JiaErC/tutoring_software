//这是登录页面
import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:provider/provider.dart";
import "package:tutoring_software/pages/router.dart";

class LoginMenu extends StatefulWidget {
  const LoginMenu({super.key});

  @override
  State<LoginMenu> createState() => _LoginMenuState();
}

//一个常用属性反馈器
class NavigationBarState extends ChangeNotifier {
  int _selectedIndex = 0; //导航的索引
  // bool _isHide = false; //导航是否隐藏，true为隐藏
  // bool _isBottom = false; //导航栏是否在底部，true为底部
  bool _isTop = false; //导航栏是否在顶部，true位顶部

  //只读属性
  int get selectedIndex => _selectedIndex;
  // bool get isHide => _isHide;
  // bool get isBottom => _isBottom;
  bool get isTop => _isTop;

  void updateSelectedIndex(int pageIndex) {
    //获取当前页面的索引
    _selectedIndex = pageIndex;
    notifyListeners();
  }

  // void hideNavigate() {
  //   //隐藏导航栏
  //   _isHide = true;
  //   notifyListeners();
  // }
  // void showNavigate() {
  //   //显示导航栏
  //   _isHide = false;
  //   notifyListeners();
  // }
}

class _LoginMenuState extends State<LoginMenu> {
  //定义头部导航栏
  late TabController _tabController;
    final PageController _page = PageController();

  //给头部导航栏赋值
//   @override
// void initState() {
//   super.initState();
//   _tabController = TabController(length: menu.size, vsync: this);
//   _tabController.addListener(() {
//     if (_tabController.index != state.selectedIndex) {
//       state.updateSelectedIndex(_tabController.index);
//       Modular.to.navigate("/tab${menu.getPath(_tabController.index)}/");
//     }
//   });
// }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationBarState(),
      child: Consumer<NavigationBarState>(
        builder: (context, state, _) {
          return OrientationBuilder(
            builder: (context, orientation) {
              state._isTop = orientation == Orientation.portrait;
              return orientation != Orientation.portrait
                  ? sideMenuWidget(context, state)
                  : topMenuWidget(context, state);
            },
          );
        },
      ),
    );
  }

  //顶部导航栏
  Widget topMenuWidget(BuildContext context, NavigationBarState state) {
    return Column(children: [
      //顶部的导航栏实现
      Expanded(
        flex:1,
        child:TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon:Icon(Icons.password_outlined),text:"密码"),
            Tab(icon:Icon(Icons.message_outlined),text:"短信"),
            Tab(icon:Icon(Icons.qr_code_outlined),text:"扫码")
          ],
          //按钮被按压之后的效果
          onTap:(index){
            state.updateSelectedIndex(index);
            Modular.to.navigate("/tab${login.getPath(index)}/");
          }
        )
        /*NavigationRail(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                groupAlignment: 1.0,
                labelType: NavigationRailLabelType.selected,
                destinations: const <NavigationRailDestination>[
                  NavigationRailDestination(
                    selectedIcon: Icon(Icons.home),
                    icon: Icon(Icons.home_outlined),
                    label: Text('主页'),
                  ),
                  NavigationRailDestination(
                    selectedIcon: Icon(Icons.chat),
                    icon: Icon(Icons.chat_outlined),
                    label: Text('聊天'),
                  ),
                  NavigationRailDestination(
                    selectedIcon: Icon(Icons.book),
                    icon: Icon(Icons.book_outlined),
                    label: Text('练习'),
                  ),
                  NavigationRailDestination(
                    selectedIcon: Icon(Icons.settings),
                    icon: Icon(Icons.settings_outlined),
                    label: Text('我的'),
                  ),
                ],
                selectedIndex: state.selectedIndex,
                onDestinationSelected: (int index) {
                state.updateSelectedIndex(index);
                Modular.to.navigate("/tab${menu.getPath(index)}/");
              },
      )*/),
      Expanded(
        flex:9,
        child:Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _page,
          itemCount: login.size,
          itemBuilder: (_, __) => const RouterOutlet(),
        ),
      ))
    ],);
    /* Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _page,
          itemCount: menu.size,
          itemBuilder: (_, __) => const RouterOutlet(),
        ),
      ),
      bottomNavigationBar: state.isHide
          ? const SizedBox(height: 0)
          : NavigationBar(
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: '主页',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.chat),
                  icon: Icon(Icons.chat_outlined),
                  label: '聊天',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.book),
                  icon: Icon(Icons.book_outlined),
                  label: '练习',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.settings),
                  icon: Icon(Icons.settings_outlined),
                  label: '我的',
                ),
              ],
              selectedIndex: state.selectedIndex,
              onDestinationSelected: (int index) {
                state.updateSelectedIndex(index);
                Modular.to.navigate("/tab${menu.getPath(index)}/");
              },
            ),
    );*/
  }

  //侧边导航栏
  Widget sideMenuWidget(BuildContext context, NavigationBarState state){
    return Container();
  }
}
