import 'package:flutter/material.dart';

class PrincipalChatScreen extends StatefulWidget {
  @override
  _PrincipalChatScreenState createState() => _PrincipalChatScreenState();
}

class _PrincipalChatScreenState extends State<PrincipalChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('NO Chat Yet')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.add),
      ),
    );
  }
}
