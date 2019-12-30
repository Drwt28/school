import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_magna/Model/Database/db.dart';
import 'package:school_magna/Services/Student.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendencePage extends StatefulWidget {
  String tag;

  AttendencePage(this.tag);

  @override
  _AttendencePageState createState() => _AttendencePageState();
}

class _AttendencePageState extends State<AttendencePage> {
  var _db = DatabaseService();

  List<Student> students = [];
  Color selectColor = Colors.blue;

  List<String> absentList = List(),
      presentList = List(),
      leaveList = List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var pref = Provider.of<SharedPreferences>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('schools')
            .document(pref.getString('school'))
            .collection('students')
            .where('classId', isEqualTo: user.email)
            .snapshots(),
        builder: (context, query) {
          return (query.data != null && query.data.documents.length > 0)
              ? Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  primary: true,
                  expandedHeight:
                  MediaQuery
                      .of(context)
                      .size
                      .height * 0.4,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    title: Text('Attendence'),
                    background: Center(
                      child: SizedBox(
                          height: 200, width: 200, child: buildTopBox()),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (context, i) =>
                          buildAttendenceTile(query.data.documents[i], i),
                      childCount: query.data.documents.length),
                )
              ],
            ),
            persistentFooterButtons: <Widget>[
              SafeArea(
                child: CupertinoButton(
                    onPressed: () {
                      updateAttendece(
                          pref.getString('school'), query.data.documents);
                    },
                    color: Colors.lightBlue,
                    child: Text('Take Attendence')),
              )
            ],
          )
              : CircularProgressIndicator();
        });
  }

  static List<bool> triple = [false, false, false];
  List<List<bool>> isSelected =
  List.generate(200, (_) => [false, false, false]);

  Widget buildAttendenceTile(DocumentSnapshot snap, int i) {
    return ListTile(
      title: Text("\t" + snap.data['name']),
      trailing: ToggleButtons(
        fillColor: Colors.white,
        disabledColor: Colors.black12,
        selectedBorderColor: Colors.blue,
        borderRadius: BorderRadius.circular(2),
        selectedColor: selectColor,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: buildAttendence("A"),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: buildAttendence("P"),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: buildAttendence('L'),
          )
        ],
        onPressed: (int index) {
          setState(() {
            int j = 0;
            for (var c in isSelected[i]) {
              if (isSelected[i][j]) {
                isSelected[i][j] = false;
              }
              j++;
            }
            isSelected[i][index] = true;
            if (index == 0) {
              absentList.add(snap.data['id']);
              presentList.remove(snap.data['id']);
              leaveList.remove(snap.data['id']);
            } else if (index == 1) {
              presentList.add(snap.data['id']);
              absentList.remove(snap.data['id']);
              leaveList.remove(snap.data['id']);
            } else {
              leaveList.add(snap.data['id']);
              presentList.remove(snap.data['id']);
              absentList.remove(snap.data['id']);
            }
          });
        },
        isSelected: isSelected[i],
      ),
    );
  }

  Widget buildAttendence(String a) {
    return Text(a, style: TextStyle(fontSize: 28));
  }

  buildWidget() {}

  Widget buildTopBox() {
    return Hero(
      tag: 'attendence',
      child: Image(
        image: AssetImage('assets/teacher/attendence.png'),
      ),
    );
  }

  void getStudentsData(String classId, schoolId) {
    setState(() {
      this.students = _db.getStudents(classId, schoolId);
    });

    print(students);
  }

//
//  StreamBuilder<QuerySnapshot>(
//  stream: Firestore.instance.collection('schools').document(pref.getString('school'))
//      .collection('students').where('classId',isEqualTo:"1" ).snapshots(),
//
//  builder: (context,snapshots)
//  {
//  return
//  ListView.builder(
//  itemCount: 30,
//  itemBuilder: (context,index){
//  return buildAttendenceList('name', index);
//  });
//
//  },
//  )

  updateAttendece(String id, List<DocumentSnapshot> snap) {
    var db = Firestore.instance.collection('schools/$id/students');

    for (var doc in snap) {
      var id = doc.documentID;
      print(id);

      if (absentList.contains(id)) {
        List list = doc.data['absentList'];

        if (list == null) {
          list = List();
        }
        list.add(Timestamp.now());

        db.document(id).updateData({'absentList': list});
      } else if (presentList.contains(id)) {
        List list = doc.data['presentList'];

        try {
          list.add(Timestamp.now());
        } catch (e) {
          list = new List();
          list.add(Timestamp.now());
        }


        db.document(id).updateData({'presentList': list});
      } else if (leaveList.contains(id)) {
        List list = doc.data['leaveList'];

        list.add(Timestamp.now());

        db.document(id).updateData({'leaveList': list});
      }
    }
    print(absentList);
  }
}

class AttendenceWidget extends StatefulWidget {
  String rollNo, name;

  String id;

  int click;

  int index;

  CallbackAction onpressed;

  int onPressed(int val) {
    this.click = val;
  }

  AttendenceWidget(
      {this.rollNo, this.name, this.id, this.click, this.onpressed});

  @override
  _AttendenceWidgetState createState() => _AttendenceWidgetState();
}

class _AttendenceWidgetState extends State<AttendenceWidget> {
  List<String> absentList = List(),
      presentList = List(),
      leaveList = List();
  List<bool> triple = [false, false, false];
  List<List<bool>> isSelected =
  List.generate(200, (_) => [false, false, false]);
  Color selectColor = Colors.blue;

  Widget buildAttendence(String a) {
    return Text(a, style: TextStyle(fontSize: 30));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("\t" + widget.name),
      trailing: ToggleButtons(
        disabledColor: Colors.black12,
        borderRadius: BorderRadius.circular(2),
        selectedColor: selectColor,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: buildAttendence("A"),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: buildAttendence("P"),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: buildAttendence('L'),
          )
        ],
        onPressed: (int index) {
          setState(() {
            isSelected[widget.index][index] = true;
            if (index == 0) {
              absentList.add(widget.id);
            } else if (index == 1) {
              presentList.add(widget.id);
            } else {
              leaveList.add(widget.id);
            }
          });
        },
        isSelected: isSelected[widget.index],
      ),
    );
  }
}
