import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_magna/Principal/CreateChatPage.dart';
import 'package:school_magna/Principal/notices.dart';
import 'package:school_magna/Principal/principal_chat_screen.dart';
import 'package:school_magna/Principal/visual_data_screen.dart';

class PrincipalHomeScreen extends StatefulWidget {
  @override
  _PrincipalHomeScreenState createState() => _PrincipalHomeScreenState();
}

class _PrincipalHomeScreenState extends State<PrincipalHomeScreen> {
  int currentTabIndex = 0;

  onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  int _currentTabIndex = 0;
  final List<Widget> _children = [
    Visualization(),
    Notices(),
    CreateChatListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentTabIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentTabIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.description),
            title: Text('Notice'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Chat'),
          ),
        ],
      ),
    );
  }
}
