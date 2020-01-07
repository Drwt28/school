import 'package:flutter/material.dart';
import 'package:school_magna/Student/StudentInfo/Homework/detailHomeWorkPage.dart';
import 'package:school_magna/Student/StudentInfo/attendent_page.dart';
import 'package:school_magna/Student/StudentInfo/result_page.dart';
import 'package:school_magna/Student/StudentInfo/student_home_page.dart';
import 'package:school_magna/main.dart';
import 'package:school_magna/selectPanel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  PageController controller = PageController();
  ScrollController listViewController = ScrollController();
  String title = "title";
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    AttendentPage(),
    DetailHomeWorkPage(list: ['Hindi', 'English'],),
    ResultPage(),

  ];

  final List<String> _childrenText = [
    'Home',
    'Attendece',
    'Homework',
    'Result'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: buildHomePage(),

//      body: _children[_currentIndex],
//      bottomNavigationBar: BottomNavigationBar(
//        onTap: onTapTabbed,
//        selectedItemColor: Colors.blue,
//        unselectedItemColor: Colors.blueGrey,
//        currentIndex: _currentIndex,
//        items: [
//          BottomNavigationBarItem(
//            icon: Icon(Icons.home),
//            title: Text('Home'),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.table_chart),
//            title: Text('Result'),
//          ),
//
//          BottomNavigationBarItem(
//            icon: Icon(Icons.account_circle),
//            title: Text('Homework'),
//          ), BottomNavigationBarItem(
//            icon: Icon(Icons.account_circle),
//            title: Text('Attendence'),
//          ),
//        ],
//      ),

    );
  }

  void onTapTabbed(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  buildHomePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[


        SizedBox(height: 30,),
        Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 6,

                  child: ListView.builder(
                    addRepaintBoundaries: true,
                    itemCount: _children.length,
                    controller: listViewController,
                    scrollDirection: Axis.horizontal,
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, i) =>
                    !(i == _currentIndex)
                        ? buildTopBarText(_childrenText[i], i)
                        : buildTopBarSelectedText(_childrenText[i], i),
                  ),
                ),

                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.indigo,),

                    onPressed: () {
                      showModalBottomSheet(
                          isDismissible: true,
                          useRootNavigator: true,
                          context: context, builder: (context) =>
                          Container(
                            height: 100,
                            child: Wrap(

                              children: <Widget>[
                                ListTile(
                                  title: Text('Log out'),
                                  onTap: () async {
                                    var pref = await SharedPreferences
                                        .getInstance();

                                    pref.clear().then((val) {
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(
                                          builder: (context) => MyApp()

                                      ));
                                    });
                                  },

                                )

                              ],
                            ),
                          ));
                    },
                  ),
                )

              ],
            )
        ),

        Flexible(
          flex: 8,
          child: PageView.builder(controller: controller,
              itemCount: _children.length, onPageChanged: (val) {
                setState(() {
                  _currentIndex = val;
                });
              }, itemBuilder: (context, i) => _children[i]),
        )

      ],
    );
  }

  buildTopBarText(text, i) {
    return GestureDetector(
      onTap: () {
        controller.animateToPage(i,
            duration: Duration(milliseconds: 500), curve: Curves.decelerate);
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ),
      ),
    );
  }

  Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.lightBlue, Colors.indigo],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 100, 10.0));

  buildTopBarSelectedText(text, int i) {
    print(controller.page);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w800
              , foreground: Paint()
            ..shader = linearGradient),
        ),
      ),
    );
  }
}