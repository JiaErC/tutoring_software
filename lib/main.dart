import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:tutoring_software/app_module.dart";

void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         body: const ScaffoldMenu()
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return
    // ChangeNotifierProvider(
    //   create: (_) => ThemeProvider(),
    //child:
    //目的是导航和页面管理,要求按照路由导航来显示菜单栏和相关的内容
    ModularApp(
      module: AppModule(),
      child: MaterialApp.router(
        routerDelegate: Modular.routerDelegate,
        routeInformationParser: Modular.routeInformationParser,
        title: '辅导软件',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
    //child: const AppWidget()
    //),
  }
}
