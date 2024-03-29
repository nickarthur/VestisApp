import 'package:flutter/material.dart';
import 'navigation_bar_controller.dart';

void main() => runApp(SampleApp());

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation Bar Demo',
      debugShowCheckedModeBanner: false,
      home: BottomNavigationBarController(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      ),
    );
  }
}

