import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:school_magna/Model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  bool dec = false;

  @override
  Widget build(BuildContext context) {
    var pref = Provider.of<SharedPreferences>(context);
    return Material(
      color: Colors.grey.shade300,
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .document('schools/' +
                    pref.getString('school') +
                    "/students/" +
                    pref.getString('Student'))
                .snapshots(),
            builder: (context, snapshot) {
              return (!snapshot.hasData)
                  ? CircularProgressIndicator()
                  : CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          actions: <Widget>[
                            IconButton(
                              icon: Icon(Icons.power_settings_new),
                              onPressed: () {
                                pref.clear().then((val) {
                                  if (val) {
                                    Navigator.pop(context);
                                  }
                                });
                              },
                            )
                          ],
                          centerTitle: true,
                          expandedHeight:
                              MediaQuery.of(context).size.height * 0.4,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            background: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              pageSnapping: false,
                              physics: AlwaysScrollableScrollPhysics(),
                              dragStartBehavior: DragStartBehavior.start,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: Colors.blue[100],
                                  child: Center(
                                    child: Text('$index'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SliverAnimatedList(
                          itemBuilder: (BuildContext context, i,
                              Animation<double> animation) {
                            return buildNoticeLayout(snapshot.data);
                          },
                          initialItemCount: 1,
                        ),
                        SliverAnimatedList(
                          itemBuilder: (BuildContext context, i,
                              Animation<double> animation) {
                            return buildRemarkList(snapshot.data, i);
                          },
                          initialItemCount: 2,
                        ),
                        SliverAnimatedList(
                          itemBuilder: (BuildContext context, i,
                              Animation<double> animation) {
                            return buildHomeWorkList(snapshot.data, i);
                          },
                          initialItemCount: 1,
                        )
                      ],
                    );
            }),
      ),
    );
  }

  buildNoticeLayout(DocumentSnapshot snapshot) {
    String notice = snapshot.data['notice'];

    return (notice == null)
        ? buildNoLayout('No notice yet ')
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Notice\t:',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      Text(
                        notice,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                )),
          );
  }

  buildRemarkLayout(BuildContext context) {
    var pref = Provider.of<SharedPreferences>(context);
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .document('schools/' +
              pref.getString('school') +
              "/students/" +
              pref.getString('Student'))
          .snapshots(),
      builder: (context, snap) => (snap.data.data['remark'] != null &&
              snap.data.data['remark'].length > 0)
          ? buildRemarkList(snap.data, 1)
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(
                        height: 50,
                        child: Image.asset('assets/parent/parents.png'),
                      ),
                    ),
                    Text(
                      'no remark from school',
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  buildRemarkList(DocumentSnapshot data, int i) {
    String remarkList = data.data['remark'];

    return (remarkList.isEmpty)
        ? buildNoLayout('no remark yet ')
        : (i == 0)
            ? Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    'Remarks ',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )),
                ))
            : Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text('Monday'),
                  subtitle: (Text(remarkList)),
                ),
              );
  }

  buildHomeWorkList(DocumentSnapshot snapshot, int i) {
    Map data = snapshot.data['homework'];

    String image =
        'https://www.google.com/imgres?imgurl=https%3A%2F%2Fi.gadgets360cdn.com%2Flarge%2Fgoogle_android_reuters_1557489952979.JPG&imgrefurl=https%3A%2F%2Fgadgets.ndtv.com%2Fapps%2Fnews%2Fandroid-apps-tracking-without-permissions-privacycon-google-play-android-q-2066852&docid=TCTwu8gGEMxlVM&tbnid=9iBl2TB3nOk-ZM%3A&vet=10ahUKEwi_pvue1c7mAhVTfisKHbDfCDsQMwiBASgKMAo..i&w=1200&h=675&bih=754&biw=1536&q=android&ved=0ahUKEwi_pvue1c7mAhVTfisKHbDfCDsQMwiBASgKMAo&iact=mrc&uact=8';
    if (data != null) {
      image = data['image'];
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('subject Name',
                style: TextStyle(fontSize: 18, color: Colors.black54)),
            SizedBox(
              height: 6,
            ),
            (image == null)
                ? SizedBox(
                    height: 130,
                    child: Image(
                      image: NetworkImage(image),
                    ),
                  )
                : SizedBox(
                    height: 1,
                  ),
            Text(
              "complete homework in subject",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            )
          ],
        ),
      ),
    );
  }

  buildNoLayout(String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              height: 50,
              child: Image.asset('assets/parent/parents.png'),
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 20, color: Colors.blue),
          )
        ],
      ),
    );
  }
}
