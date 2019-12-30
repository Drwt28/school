import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:school_magna/Services/Class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeworkTile extends StatefulWidget {
  String subjectName;

  var days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thrusday',
    'Friday',
    'Saturday'
  ];
  Firestore db = Firestore.instance;

  HomeworkTile({@required this.subjectName});

  @override
  _HomeworkTileState createState() => _HomeworkTileState();
}

class _HomeworkTileState extends State<HomeworkTile> {
  bool imageSlected = false;
  List<Asset> images = List<Asset>();
  File imageFile = null;
  bool progress = true;
  bool sent = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    var pref = Provider.of<SharedPreferences>(context);

    Asset asset;

    return (sent)
        ? sentCard(widget.subjectName)
        : Card(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                images.length > 0
                    ? Text(
                        'Selected Images',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )
                    : SizedBox(),
                images.length > 0
                    ? SizedBox(
                        height: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: AssetThumb(
                                  height: 200,
                                  width: 200,
                                  asset: images[i],
                                ),
                              );
                            }),
                      )
                    : SizedBox(),
                ListTile(
                  title: imageFile == null
                      ? Text('\t' + widget.subjectName)
                      : Center(
                          child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                  flex: 1, child: Text(widget.subjectName)),
                              Flexible(
                                  flex: 5,
                                  child: Image.file(
                                    (imageFile),
                                    fit: BoxFit.fill,
                                  ))
                            ],
                          ),
                        )),
                  isThreeLine: true,
                  contentPadding: EdgeInsets.all(5),
                  subtitle: TextField(
                    onChanged: (val) {},
                    decoration: InputDecoration(labelText: 'enter homework '),
                    controller: controller,
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Center(
                      child: imageFile != null
                          ? IconButton(
                              color: Colors.blue,
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  imageFile = null;
                                });
                              },
                            )
                          : SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      getImage(ImageSource.camera);
                                    },
                                    icon: Icon(Icons.camera_enhance),
                                    color: Colors.blue,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      getImage(ImageSource.camera);
                                    },
                                    icon: Icon(Icons.image),
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                !progress
                    ? CircularProgressIndicator()
                    : Container(
                        height: 50,
                        width: 100,
                        child: Center(
                          child: FlatButton(
                            onPressed: () {
                              if (imageFile == null || progress) {
                                uploadImageStorage(
                                    1,
                                    imageFile,
                                    user.email,
                                    controller.text,
                                    user,
                                    pref.getString('school'));
                              }
                            },
                            padding: EdgeInsets.all(5),
                            color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  'Send',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  Icons.send,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
              ],
            ),
          );
  }

  void getImage(ImageSource gallery) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = image;
    });
  }

  Future<String> uploadImageStorage(int j, var imageFile, String name,
      String text, FirebaseUser user, String schoolId) async {
    List<String> urlList = List<String>();
    String t = text;

    final FirebaseStorage storage = FirebaseStorage.instance;

    DateTime date = DateTime.now();
    StorageReference ref =
        storage.ref().child(name + widget.days[date.weekday - 1]);

    StorageUploadTask uploadTask = ref.putFile(imageFile);

    if (uploadTask.isInProgress) {
      setState(() {
        progress = false;
      });
    }

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    urlList.add(dowurl.toString());

    saveToDatabase(user, t, dowurl.toString(), schoolId);

    return "";
  }

  void saveToDatabase(
      FirebaseUser user, String t, String url, String schoolId) {
    String id = user.email;
    Map<String, dynamic> homework = Map();

    DateTime date = DateTime.now();

    homework['day'] = widget.days[date.weekday];
    String day = widget.days[date.weekday].toLowerCase();
    DocumentReference doc = Firestore.instance
        .document('schools/$schoolId/classes/$id/homework/$day');

    homework['image'] = url ?? "";

    homework['text'] = t;
    doc.setData(homework).then((val) {
      setState(() {
        sent = true;
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  sentCard(String subjectName) {
    return Card(
      child: ListTile(
          trailing: IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.blue,
              size: 35,
            ),
            onPressed: () {
              setState(() {
                sent = false;
                progress = true;
                imageFile = null;
              });
            },
          ),
          onTap: () {
            setState(() {
              sent = false;
              progress = true;
              imageFile = null;
            });
          },
          title: Text(
            '$subjectName home work sent succesfully',
            style: TextStyle(color: Colors.green, fontSize: 18),
          ),
          leading: Icon(
            Icons.check,
            color: Colors.green,
            size: 40,
          )),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        selectedAssets: images,
        enableCamera: true,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Slect Homework ",
          allViewTitle: "All Photos",
          useDetailsView: false,
          autoCloseOnSelectionLimit: true,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;

      print(images[0].name);
    });
  }
}
