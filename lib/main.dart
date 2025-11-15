import 'dart:io';

import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import "package:tutoring_software/app_module.dart";
import 'package:tutoring_software/utils/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*代码源于Kazumi*/
  /*需要添加media_kit库*/
  //   MediaKit.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
  }
  /*Kazumi初始化Hive数据库 */
  try {
    Hive.init('${(await getApplicationSupportDirectory()).path}/hive');
    await GStorage.init();
  } catch (_) {
    runApp(
      MaterialApp(
        title: '初始化失败',
        // localizationsDelegates: GlobalMaterialLocalizations.delegates,
        // supportedLocales: const [
        //   Locale.fromSubtags(
        //       languageCode: 'zh', scriptCode: 'Hans', countryCode: "CN")
        // ],
        // locale: const Locale.fromSubtags(
        //     languageCode: 'zh', scriptCode: 'Hans', countryCode: "CN"),
        // builder: (context, child) {
        //   return const StorageErrorPage();
        // }
      ),
    );
    return;
  }
  runApp(MyApp());
}

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
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
    //child: const AppWidget()
    //),
  }
}
