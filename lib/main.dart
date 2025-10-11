import "package:flutter/material.dart";
import "package:tutoring_software/pages/menu/menu.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: const ScaffoldMenu()
      ),
    );
  }
}
