import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

class AttendentPage extends StatefulWidget {
  @override
  _AttendentPageState createState() => _AttendentPageState();
}

class _AttendentPageState extends State<AttendentPage> {
  DateTime _currentDate;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Card(
          color: Colors.grey.shade200,
          elevation: 0.4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Colors.yellow.shade300,
                  Colors.grey,
                  Colors.indigo.shade300
                ])),
            child: CalendarCarousel(),
          ),
        ),
      ),
    );
  }
}
