import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:school_magna/Model/Database/db.dart';
import 'package:school_magna/Model/model.dart';
import 'package:school_magna/Services/Teacher.dart';
import 'package:school_magna/Teacher/functions/AddStudent.dart';
import 'package:school_magna/Teacher/functions/AttendenceScreen.dart';
import 'package:school_magna/Teacher/functions/NoticeScreen.dart';
import 'package:school_magna/Teacher/functions/feesNotificationScreen.dart';
import 'package:school_magna/Teacher/functions/homeWork.dart';
import 'package:school_magna/Teacher/functions/remarkScreen.dart';
import 'package:school_magna/Teacher/functions/studentListScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherHomePage extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  Teacher teacher = Teacher();

  int currentItem = 0;

  PageController pageController = PageController(
      initialPage: 0
  );

  List<dynamic> subList = List();

  FirebaseUser user;

  final db = DatabaseService();

  @override
  void initState() {
    super.initState();
    setState(() {
      getData();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: currentItem == 0 ? HomePage() : ChatPage(),

      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        onTap: (val) {
          setState(() {
            currentItem = val;
          });
        },

        currentIndex: currentItem,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home, color: Colors.blue,),
              title: Text('Home')

          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat, color: Colors.indigo),
              title: Text('Chat')

          )
        ],
      ),
    );
  }

  teacherDashBoard(Map<String, dynamic> map) {
//    Class c = Class.fromMap(map);

    var teacher = Provider.of<DocumentSnapshot>(context);

    print(teacher.data.toString());
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(map['teacherName'],
              style: TextStyle(color: Colors.black, fontSize: 20)),
          SizedBox(
            height: 10,
          ),
          Text(map['className'] + "\t" + map['section'],
              style: TextStyle(color: Colors.black, fontSize: 16)),
          SizedBox(
            height: 10,
          ),
          buildDashboardText('last Attendence Date :' + ''),
          SizedBox(height: 6),
          buildDashboardText('last notice :' + map['notice']),
          SizedBox(height: 6),
          buildDashboardText(
              'present students :' + map['presentStudents'].toString())
        ],
      ),
    );
  }

  Widget buildDashboardText(String text) {
    return Text(text, style: TextStyle(color: Colors.black, fontSize: 16));
  }

  Future<String> getData() async {
    var pref = await SharedPreferences.getInstance();
    var user = await FirebaseAuth.instance.currentUser();
    if (pref != null) {
      Firestore.instance.document(
          'schools/' + pref.getString('school') + '/classes/' + user.email)
          .get().then((snap) {
        setState(() {
          this.subList = snap.data['subjectList'];
          print(subList);
        });
      });
    }
  }

  HomePage() {
    user = Provider.of<FirebaseUser>(context);
    var pref = Provider.of<SharedPreferences>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(

          slivers: <Widget>[
            SliverAppBar(
              primary: true,

              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddStudentPage(this.subList)));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().whenComplete(() {
                      Navigator.of(context).pop();
                    });
                  },
                )
              ],
              leading: Padding(
                padding: const EdgeInsets.all(6.0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image(
                    image: AssetImage('assets/teacher/teacher.png'),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              expandedHeight: MediaQuery.of(context).size.height * 0.34,
              flexibleSpace: FlexibleSpaceBar(

                collapseMode: CollapseMode.pin,
                background: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: SafeArea(
                    top: true,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 58.0),
                        child: AnimatedContainer(
                          duration: Duration(seconds: 2),
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection('schools')
                                .document(pref.getString('school'))
                                .collection('classes')
                                .document(user.email)
                                .snapshots(),
                            builder: (context, snap) {
                              var s = snap.data;
                              if (s != null && s.exists)
                                return teacherDashBoard(snap.data.data);
                              else
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 1,
              childAspectRatio: 3.5,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => feesNotificationPage()));
                    },
                    child: CustomWidgets.teacherHomePannelCardHeroSingle(
                        context,
                        'Fee Notification',
                        'assets/teacher/fees.png',
                        Colors.blue,
                        Colors.indigo,
                        'fees'))
              ],
            ),
            SliverGrid.count(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => NoticePage()));
                  },
                  child: CustomWidgets.teacherHomePannelCardHero(
                      context,
                      'Notice',
                      'assets/teacher/notice.png',
                      Colors.blue,
                      Colors.lightBlue,
                      'notice'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RemarkPage()));
                  },
                  child: CustomWidgets.teacherHomePannelCardHero(
                      context,
                      'Remarks',
                      'assets/teacher/remark.png',
                      Colors.indigoAccent,
                      Colors.blueAccent,
                      'remark'),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AttendencePage('attendence')));
                    },
                    child: CustomWidgets.teacherHomePannelCardHero(
                        context,
                        'Attendence',
                        'assets/teacher/attendence.png',
                        Colors.indigoAccent,
                        Colors.indigo,
                        'attendence')),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            homeworkPage(

                            )));
                  },
                  child: CustomWidgets.teacherHomePannelCardHero(
                      context,
                      'HomeWork',
                      'assets/teacher/homework.png',
                      Colors.blue,
                      Colors.indigoAccent,
                      'homework'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentListPage()));
                  },
                  child: CustomWidgets.teacherHomePannelCardHero(
                      context,
                      'Students ',
                      'assets/teacher/student.png',
                      Colors.blue,
                      Colors.lightBlue,
                      'studentList'),
                ),
                CustomWidgets.teacherHomePannelCard(
                    context,
                    'Result',
                    'assets/teacher/exam.png',
                    Colors.indigo,
                    Colors.indigoAccent)
              ],
            )
          ],
        ));
  }

  ChatPage() {
    user = Provider.of<FirebaseUser>(context);
    var pref = Provider.of<SharedPreferences>(context);


    return Scaffold(
      appBar: AppBar(

        title: Text('Chat'),
      ),

      body: user.email == null ? CircularProgressIndicator() : StreamBuilder<
          QuerySnapshot>(
        stream: Firestore.instance
            .collection('schools')
            .document(pref.getString('school'))
            .collection('classes')
            .document(user.email)
            .collection('chats')
            .snapshots(),
        builder: (context, query) =>
        (query != null && query.data.documents.length > 0)
            ? buildStudentChatList(query.data.documents)
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(height: 100,
                  child: Image.asset('assets/teacher/teacher.png'),),

              )
              ,
              Text('No Messages Yet',
                style: TextStyle(fontSize: 30, color: Colors.blue),)
            ],
          ),
        ),

      ),

    );
  }

  buildStudentChatList(List<DocumentSnapshot> documents) {


  }



}
