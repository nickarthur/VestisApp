import 'package:flutter/material.dart';
import 'page1.dart';
import 'page2.dart';

class BottomNavigationBarController extends StatefulWidget {
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState extends State<BottomNavigationBarController> {
  static final page1 = new FirstPage();
  static final page2 = new SecondPage();

  final List<Widget> pages = [
    page2,
    page1,
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) =>
      SizedBox(
        height: 110,
        child: BottomNavigationBar(
        onTap: (int index) => setState(() => _selectedIndex = index),
        currentIndex: selectedIndex,
//        backgroundColor: Colors.grey[850],
//        selectedItemColor: Colors.white,
//        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.grey[700],
        unselectedItemColor: Colors.grey[600],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), title: Text('Map')),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt), title: Text('Finder')),
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}