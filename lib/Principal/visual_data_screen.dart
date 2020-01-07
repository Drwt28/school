import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//student class
class Attendence {
//  final String week;
//  final int number;
//  Attendence(this.month, this.number);
  Attendence({this.week, this.number});

  Attendence.fromMap(Map<String, dynamic> dataMap)
      : week = dataMap['attendenceList'],
        number = dataMap['attendenceList'];
  final String week;
  final int number;
}

class Visualization extends StatefulWidget {
  @override
  _VisualizationState createState() => _VisualizationState();
}

class _VisualizationState extends State<Visualization> {
  final data = [];
  int _value = 1;
  List<List<Attendence>> list = new List<List<Attendence>>();

  @override
  Widget build(BuildContext context) {
    var pref = Provider.of<SharedPreferences>(context);
    String id = pref.get('school');
    return StreamBuilder<QuerySnapshot>(
        stream:
        Firestore.instance.collection('schools/$id/classes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int index = 0;
            index < snapshot.data.documents.length;
            index++) {
              DocumentSnapshot documentSnapshot =
              snapshot.data.documents[index];
              list.add(getDataFromMap(documentSnapshot.data['attendenceList']));
            }
          }
          return Center(
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RotationTransition(
                        turns: AlwaysStoppedAnimation(-45 / 360),
                        child: Text(
                          "Class",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 28.0,
                              color: Colors.indigo),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: buildClassClip(),
                      ),
                    )
                  ],
                ),
                data.isEmpty
                    ? Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 60.0,
                  ),
                  child: Center(
                    child: Text(
                      'No Data Yet',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 24.0),
                    ),
                  ),
                )
                    : buildCard(context),
              ],
            ),
          );
        });
  }

  Card buildCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 3.0,
      child: Container(
        height: MediaQuery.of(context).size.height * .5,
        child: charts.BarChart(
          _createVisualizationData(),
          animate: true,
          behaviors: [
            charts.ChartTitle('Number of Student',
                behaviorPosition: charts.BehaviorPosition.start),
            charts.ChartTitle('Weeks',
                behaviorPosition: charts.BehaviorPosition.bottom)
          ],
        ),
      ),
    );
  }

  Wrap buildClassClip() {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 8.0,
      runAlignment: WrapAlignment.end,
      children: List<Widget>.generate(
        12,
            (int index) {
          return FilterChip(
            autofocus: true,
            selectedColor: Colors.indigoAccent,
            label: Text('${index + 1}'),
            selected: _value == index,
            onSelected: (bool selected) {
              setState(() {
                _value = selected ? index : index;
              });
            },
          );
        },
      ).toList(),
    );
  }

  List<charts.Series<Attendence, String>> _createVisualizationData() {
    return [
      charts.Series<Attendence, String>(
          id: 'StudentAttendence',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (Attendence dataPoint, _) => dataPoint.week.toString(),
          measureFn: (Attendence dataPoint, _) => dataPoint.number,
          data: data)
    ];
  }

  List<Attendence> getDataFromMap(Map map) {
    List<Attendence> attendence = [];
    String s = map.toString();
    int i = map.toString().indexOf(',');
    while (i > 0) {
      try {
        String l = s.substring(0, i);
        attendence.add(Attendence(
            week: l.substring(0, l.indexOf(':')).replaceFirst('{', ""),
            number: map[l
                .substring(0, l.indexOf(':'))
                .toString()
                .replaceFirst("{", "")
                .trim()]));
        s = s.substring(i + 1, s.length - 1);
        i = s.indexOf(',');
      } catch (e) {
        break;
      }
    }
    for (var a in attendence) {
      print(a.week);
      print(a.number);
    }
    return attendence;
  }
}
