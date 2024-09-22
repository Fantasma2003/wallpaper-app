import 'package:flutter/material.dart';
import 'package:wallpaper_app/custom_scroll_behaviour.dart';
import 'package:wallpaper_app/main_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollBehaviour(),
      home: const MainPage(),
    );
  }
}
