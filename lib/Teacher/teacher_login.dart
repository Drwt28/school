import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_magna/Teacher/classBuilderScreen.dart';
import 'package:school_magna/Teacher/teacherHome.dart';
import 'package:school_magna/Principal/principal_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class teacher_login extends StatefulWidget {
  @override
  _teacher_loginState createState() => _teacher_loginState();
}

class _teacher_loginState extends State<teacher_login> {
  FirebaseUser user;
  bool dec = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String _e, _p;
  String designation;


  @override
  initState() {
    super.initState();
    checkForSignIn();
  }

  Future checkForSignIn() async {
    user = await FirebaseAuth.instance.currentUser();

    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => classBuilderScreen()
      ));
    }
  }

  @override
  Widget build(BuildContext context) {

    user = Provider.of<FirebaseUser>(context);
    var pref = Provider.of<SharedPreferences>(context);


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(
                height: 130,
                width: 130,
                child: buildTopBox()),

            Center(
              widthFactor: MediaQuery.of(context).size.width * 0.85,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      onSaved: (val) {
                        _e = val;
                      },
                      controller: email,
                      style: TextStyle(fontSize: 18),
                      obscureText: false,
                      decoration: InputDecoration(

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          labelText: 'teacher id', icon: Icon(Icons.email)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onSaved: (val) {
                        _p = val;
                      },
                      onChanged: (val) {
                        setState(() {
                          _p = val;
                        });
                      },
                      controller: password,
                      obscureText: true,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),

                          labelText: 'password', icon: Icon(Icons.security)),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: buildClassDropDown(context),
                      ),
                    )
                    ,
                    SizedBox(height: 10),
                    dec ? CircularProgressIndicator() : Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: CupertinoButton(
                        color: Colors.blue,
                        child:Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                                setState(() {
                                  dec = true;
                                });

                                if (designation == null) {
                                  showDialog(
                                      context: context, child: AlertDialog(
                                    title: Icon(
                                      Icons.warning, color: Colors.yellow,),
                                    content: Text(
                                      'select your Designation for login',
                                      style: TextStyle(
                                          fontSize: 17
                                      ),),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            dec = false;
                                          });
                                        },
                                        child: Text('OK'),
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                      )
                                    ],)

                                  );
                                } else if (designation == 'Principal') {
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(
                                      builder: (context) =>
                                          PrincipalHomeScreen()
                                  ));
                                } else {
                                  Signin(email.text, password.text, pref);
                          }

                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

  }


  Widget buildTopBox() {
    return Hero(
      tag: 'teacher',
      child: Image(
        image: AssetImage('assets/teacher/teacher.png'),
      ),
    );
  }

  Widget buildClassDropDown(BuildContext context) {
    return SizedBox(
        height: 50,
        child: DropdownButton<String>(
          value: designation,
          icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
          iconSize: 28,
          hint: Text("select your designation ",style: TextStyle(
            color: Colors.blue,fontSize: 16
          ),),
          elevation: 16,
          style: TextStyle(color: Colors.indigo),
          underline: Container(
            height: 1,
            color: Colors.blue,
          ),
          onChanged: (String newValue) {
            setState(() {
              designation = newValue;
            });
          },
          items: <String>[
            'Teacher'
            , 'Principal'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value, style: TextStyle(color: Colors.black, fontSize: 20),),
            );
          }).toList(),
        ));
  }

  Signin(String id, pass, SharedPreferences pref) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim())
        .then((AuthResult result) {
      print(result.user);


      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => classBuilderScreen()));
    }).catchError((Error e) {
      setState(() {
        showDialog(context: context, child: AlertDialog(
          title: Icon(Icons.warning, color: Colors.yellow,),
          content: Text(e.toString(), style: TextStyle(
              fontSize: 17
          ),),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  dec = false;
                });
              },
              child: Text('OK'),
              color: Colors.blue,
              textColor: Colors.white,
            )
          ],)

        );
        dec = false;
      });
    });
  }

}
