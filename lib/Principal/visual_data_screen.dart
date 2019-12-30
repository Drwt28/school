import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

//student class
class Attendence {
  final String month;
  final int number;

  Attendence(this.month, this.number);
}

class Visualization extends StatefulWidget {
  @override
  _VisualizationState createState() => _VisualizationState();
}

class _VisualizationState extends State<Visualization> {
  final data = [
    Attendence('Mon', 25),
    Attendence('Tue', 26),
    Attendence('Wen', 24),
    Attendence('Thur', 10),
    Attendence('Fri', 40),
    Attendence('Sat', 20)
  ];
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: <Widget>[
          buildClassClip(),
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
      children: List<Widget>.generate(
        12,
        (int index) {
          return FilterChip(
            label: Text('Class${index + 1}'),
            selected: _value == index,
            onSelected: (bool selected) {
              setState(() {
                _value = selected ? index : null;
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
          domainFn: (Attendence dataPoint, _) => dataPoint.month,
          measureFn: (Attendence dataPoint, _) => dataPoint.number,
          data: data)
    ];
  }
}
