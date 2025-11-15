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
  final bool _isTop = false; //导航栏是否在顶部，true位顶部

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

class _LoginMenuState extends State<LoginMenu>
    with SingleTickerProviderStateMixin
//with SingleTickerProviderStateMixin
{
  //定义头部导航栏
  late TabController _tabController;
  final PageController _page = PageController();

  // 给头部导航栏赋值
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: login.size, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // 导航到对应页面
        Modular.to.navigate("/login${login.getPath(_tabController.index)}/");
        // 同步更新PageView
        _page.jumpToPage(_tabController.index);
      }
    });
  }

  //释放资源
  @override
  void dispose() {
    // 必须先释放_tabController，然后再调用super.dispose()
    _tabController.dispose();
    super.dispose();
  }

  int getCurrentTabIndex() {
    return _tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationBarState(),
      child: Consumer<NavigationBarState>(
        builder: (context, state, _) {
          return topMenuWidget(context, state);
        },
      ),
    );
  }

  //间距
  late EdgeInsets padding;

  //封装前往对应页面的方法
  void goPage(int index, NavigationBarState state) {
    //点击对应的索引，跳转到对应的页面
    index = getCurrentTabIndex();
    state.updateSelectedIndex(index);
    Modular.to.navigate("/login${login.getPath(index)}/");
  }

  //顶部导航栏
  Widget topMenuWidget(BuildContext context, NavigationBarState state) {
    /*代码复用自PiliPlus*/
    padding =
        MediaQuery.viewPaddingOf(context).copyWith(top: 0) +
        const EdgeInsets.only(bottom: 25);
    //判断界面的状态，当处于横屏的时候isLandscape为true
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar:AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip:"登录",
          onPressed: () => Navigator.pop(context), // 返回上一级路由
        ),

        title: Row(
          children: [
            const Text('登录'),
            if (state.isTop)
              Expanded(child: Align(alignment: Alignment.centerRight)),
            //判断是否位横屏模式
            if (isLandscape)
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TabBar(
                    isScrollable: true,
                    dividerHeight: 0,
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.password), Text(' 密码')],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.sms_outlined), Text(' 短信')],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.qr_code), Text(' 扫码')],
                        ),
                      ),
                      // Tab(
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Icon(Icons.cookie_outlined),
                      //       Text(' Cookie'),
                      //     ],
                      //   ),
                      // ),
                    ],
                    controller: _tabController,
                    onTap: (int index) => goPage(index, state),
                  ),
                ),
              ),
          ],
        ),
        bottom: !isLandscape
            ? TabBar(
                tabs: const [
                  Tab(icon: Icon(Icons.password), text: '密码'),
                  Tab(icon: Icon(Icons.sms_outlined), text: '短信'),
                  Tab(icon: Icon(Icons.qr_code), text: '扫码'),
                  // Tab(icon: Icon(Icons.cookie_outlined), text: 'Cookie'),
                ],
                controller: _tabController,
                onTap: (int index) => goPage(index, state),
              )
            : null,
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
    );
  }
}
