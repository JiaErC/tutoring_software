/*这个文件的大部分代码复用来自Kazumi的代码*/

import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:provider/provider.dart";
import 'package:getwidget/getwidget.dart';

import "package:tutoring_software/bean/widgets/embedded_native_control_area.dart";
import "package:tutoring_software/pages/router.dart";
import "package:tutoring_software/bean/widgets/edge_box.dart";
import 'package:tutoring_software/modules/avatar/avatar_controller.dart';

class ScaffoldMenu extends StatefulWidget {
  const ScaffoldMenu({super.key});

  @override
  State<ScaffoldMenu> createState() => _ScaffoldMenu();
}

/*NavigationBarState复用来自Kazumi的代码*/
class NavigationBarState extends ChangeNotifier {
  int _selectedIndex = 0; //导航的索引
  bool _isHide = false; //导航是否隐藏，true为隐藏
  bool _isBottom = false; //导航栏是否在底部，true为底部

  //三个只读属性
  int get selectedIndex => _selectedIndex;

  bool get isHide => _isHide;

  bool get isBottom => _isBottom;

  void updateSelectedIndex(int pageIndex) {
    //获取当前页面的索引
    _selectedIndex = pageIndex;
    notifyListeners();
  }

  void hideNavigate() {
    //隐藏导航栏
    _isHide = true;
    notifyListeners();
  }

  void showNavigate() {
    //显示导航栏
    _isHide = false;
    notifyListeners();
  }
}

//菜单的主页
class _ScaffoldMenu extends State<ScaffoldMenu> {
  //头像控制器
  final AvatarController _avatarController = Modular.get<AvatarController>();

  final PageController _page = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationBarState(),
      child: Consumer<NavigationBarState>(
        builder: (context, state, _) {
          return OrientationBuilder(
            builder: (context, orientation) {
              state._isBottom = orientation == Orientation.portrait;
              return orientation != Orientation.portrait
                  ? sideMenuWidget(context, state)
                  : bottomMenuWidget(context, state);
            },
          );
        },
      ),
    );
  }

  //底部导航栏
  Widget bottomMenuWidget(BuildContext context, NavigationBarState state) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: EdgeBox(
          margin: EdgeInsets.only(left: 5, top: 5),
          child: _buildAvatar()
        ),
      ),
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
                  selectedIcon: Icon(Icons.person),
                  icon: Icon(Icons.person_outlined),
                  label: '我的',
                ),
              ],
              selectedIndex: state.selectedIndex,
              onDestinationSelected: (int index) {
                state.updateSelectedIndex(index);
                Modular.to.navigate("/tab${menu.getPath(index)}/");
              },
            ),
    );
  }

  Widget sideMenuWidget(BuildContext context, NavigationBarState state) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: Row(
        children: [
          EmbeddedNativeControlArea(
            child: Visibility(
              visible: !state.isHide,
              child: NavigationRail(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                //创建头部个人头像区域
                leading: _buildAvatar(),
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
                    selectedIcon: Icon(Icons.person),
                    icon: Icon(Icons.person_outlined),
                    label: Text('我的'),
                  ),
                ],
                selectedIndex: state.selectedIndex,
                onDestinationSelected: (int index) {
                  state.updateSelectedIndex(index);
                  Modular.to.navigate("/tab${menu.getPath(index)}/");
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                ),
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: menu.size,
                  itemBuilder: (_, __) => const RouterOutlet(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //头像区域
  Widget _buildAvatar() {
    return InkWell(
      onTap: () {
        debugPrint("点击头像");
        Modular.to.pushNamed("/tab/my");
      },
      child: GFAvatar(
        backgroundImage: _avatarController.avatarData != null
            ? MemoryImage(_avatarController.avatarData!)
            : AssetImage("lib/data/images/1.png"),
        radius: 20,
      ),
    );
  }
}
