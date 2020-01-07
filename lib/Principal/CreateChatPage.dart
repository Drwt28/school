import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateChatListPage extends StatefulWidget {
  @override
  _CreateChatListPageState createState() => _CreateChatListPageState();
}

class _CreateChatListPageState extends State<CreateChatListPage> {
  @override
  Widget build(BuildContext context) {
    var pref = Provider.of<SharedPreferences>(context);

    String schoolId = pref.getString('school');

    String id = pref.getString('principal');

    return Scaffold(
      appBar: AppBar(
        title: Text('Char List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('schools/$schoolId/classes')
            .snapshots(),
        builder: (context, query) => query.hasData
            ? buildChatList(query.data.documents, id, schoolId)
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  buildChatList(List<DocumentSnapshot> snap, String principalId, schoolId) {
    return ListView.builder(
        itemCount: snap.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(snap[i].data['teacherName']),
              subtitle:
                  Text(snap[i].data['className'] + snap[i].data['section']),
              trailing: Icon(Icons.message, color: Colors.indigo),
              onTap: () {
                createChatDocument(snap[i].documentID, principalId, schoolId);
              },
            ));
  }

  void createChatDocument(
      String documentID, String principalId, String schoolId) {
    String id = documentID;
    DocumentReference ref =
        Firestore.instance.document('schools/$schoolId/Chat/$id');

    List<String> users = [documentID, principalId];

    ref.setData(({'users': users})).then((val) => print('done'));
  }
}
