import 'package:flutter/material.dart';

class Notices extends StatefulWidget {
  @override
  _NoticesState createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 1,
//      itemCount:Provider.of<PrincipalData>(context).notices.length,
        itemBuilder: (context, index) {
          return Container(
            child: Center(child: Text("No Notice Yet")),
          );
        });
  }
}
