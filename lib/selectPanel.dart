import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_magna/Teacher/teacher_login.dart';
import 'package:school_magna/Model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Student/studentLoginPage.dart';
import 'package:school_magna/Teacher/teacherHome.dart';


class SelectionPanel extends StatelessWidget {
  int i;

  SelectionPanel(this.i);


  @override
  Widget build(BuildContext context) {
    var sharedPreferences = Provider.of<SharedPreferences>(context);
    print(sharedPreferences.get("school"));


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        title: Text(
          "Selection Panel",
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentPanel()));
                  },
                  child: CustomWidgets.SelectionPannelCard(
                      context,
                      "Parents",
                      'assets/parent/parents.png',
                      Colors.indigoAccent,
                      Colors.indigo,'parents')),
              GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => teacher_login()));
                  },
                  child: CustomWidgets.SelectionPannelCard(
                      context,
                      "Teacher",
                      'assets/teacher/teacher.png',
                      Colors.lightBlue,
                      Colors.blueAccent,'teacher'))
            ],
          ),
        ),
      ),
    );
  }

}
