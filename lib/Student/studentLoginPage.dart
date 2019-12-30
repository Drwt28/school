import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_magna/Student/studentHomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_magna/Notification/Notification.dart';
class StudentPanel extends StatefulWidget {
  @override
  _StudentPanelState createState() => _StudentPanelState();
}
class _StudentPanelState extends State<StudentPanel> {
  final _formKey = GlobalKey<FormState>();

  bool dec = false;
  var _notification = NoticationService();

  var Sname = TextEditingController(),
      Fname = TextEditingController(),
      Mname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var pref = Provider.of<SharedPreferences>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Login"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: 130,
                      width: 130,
                      child: buildTopBox()),

                  SizedBox(height: 30,),
                  TextFormField(
                    controller: Sname,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Student Name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Student Name",
                        suffixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: Fname,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter Father's Name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Father's Name",
                        suffixIcon: Icon(Icons.people),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: Mname,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter Mother's Name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Mother's Name",
                        suffixIcon: Icon(Icons.people_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                  ),
                  SizedBox(height: 20,),
                  CupertinoButton(
                    color: Colors.indigo,
                    onPressed: () {
                      try {
                        signIn(Sname.text.toLowerCase().trim(), Fname.text
                            .toLowerCase().trim(), Mname.text.toLowerCase()
                            .trim(),
                            pref.getString('school'), pref);
                      } catch (error) {
                        print(error.toString());
                      }
                      if (_formKey.currentState.validate()) {


                      } else {

                      }
                    },
                    child: Text('Sign In'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopBox() {
    return Hero(
        tag: 'parents',
        child: Image(
          image: AssetImage('assets/parent/parents.png'),
        )
    );
  }

  signIn(s, f, String m, id, SharedPreferences pref) async {
    var database = Firestore.instance.collection('schools')
        .document(id)
        .collection('students');

    var snap = await database.where('id', isEqualTo: s + f + m)
        .getDocuments();

    print(s + f + m);
    if (snap != null && snap.documents.length > 0) {
      pref.setString('Student', snap.documents[0].documentID);


      _notification.saveUserToken(s + f + m);


      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StudentHome()
      ));
    }
    else {
      print("Error no students were found");
//      _formKey.currentState.initState();
//      _formKey.currentState.validate();
    }
  }
}