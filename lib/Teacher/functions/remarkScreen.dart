import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemarkPage extends StatefulWidget {
  @override
  _RemarkPageState createState() => _RemarkPageState();
}

class _RemarkPageState extends State<RemarkPage> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var pref = Provider.of<SharedPreferences>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Remark'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: SizedBox(
                height: 90,
                width: 90,
                child: buildTopBox(),
              ),
            ),
            Flexible(
              flex: 7,
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('schools')
                    .document(pref.getString('school'))
                    .collection('students')
                    .where('classId', isEqualTo: user.email)
                    .snapshots(),
                builder: (context, query) {
                  return (query.data != null && query.data.documents.length > 0)
                      ? buildRemarkList(query.data.documents)
                      : CircularProgressIndicator();
                },
              ),
            ),
          ],
        ));
  }
  Widget buildTopBox() {
    return Hero(
      tag: 'remark',
      child: Image(
        image: AssetImage('assets/teacher/remark.png'),
      ),
    );
  }

  buildRemarkList(List<DocumentSnapshot> documents) {
    
    return ListView.builder(
    itemCount: documents.length
    ,itemBuilder: (context,index){
      return buildRemarkItem(documents[index]['name'], index.toString()); 
    });
    
  }
  
  buildRemarkItem(String name,rollno)
  {
    return ListTile(
      title: Text(rollno + name),
      isThreeLine: true,
      contentPadding: EdgeInsets.all(5),
      subtitle: TextField(decoration: InputDecoration(
        labelText: 'enter remark '
      ),),
      
      trailing: IconButton(
        onPressed: (){

        },
        icon: Icon(Icons.send),
        color: Colors.blue,
      ),
    );
  }
}
