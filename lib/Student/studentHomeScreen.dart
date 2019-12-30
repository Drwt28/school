import 'package:flutter/material.dart';
import 'package:school_magna/Student/StudentInfo/attendent_page.dart';
import 'package:school_magna/Student/StudentInfo/result_page.dart';
import 'package:school_magna/Student/StudentInfo/student_home_page.dart';

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  String title = "title";
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    ResultPage(),
    AttendentPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTapTabbed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.blueGrey,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.table_chart),
                title: Text('Result'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                title: Text('Attendence'),
              ),
            ],
          ),
        ));
  }

  void onTapTabbed(int value) {
    setState(() {
      _currentIndex = value;
    });
  }
}