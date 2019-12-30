import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StudentInformationList(),
              SizedBox(
                height: 20.0,
              ),
              Flexible(child: ResultTable()),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentInformationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .2,
      child: Card(
        elevation: 1.0,
        child: Container(
          decoration: BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
                // Add one stop for each color. Stops should increase from 0 to 1
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  Colors.indigo,
                  Colors.blueAccent
                ],
              ),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2.0,
                    blurRadius: 4.0,
                    color: Colors.grey.shade300)
              ]),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/parent/parents.png',
                    ),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              title: Column(
                children: <Widget>[
                  Text('Name:'),
                  Text("Father's Name:"),
                  Text("Mother's Name:"),
                  Text('Roll No:'),
                ],
              )),
        ),
      ),
    );
  }
}

class ResultTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          spreadRadius: 3.0,
          blurRadius: 2.0,
        )
      ]),
      child: Card(
        elevation: 1.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            DataTable(
              columns: [
                DataColumn(
                    label: Text('Subject',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ))),
                DataColumn(
                    label: Text('Total\nMarks',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ))),
                DataColumn(
                    label: Text('Marks\nObtained',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ))),
              ],
              rows: items
                  .map(
                    (itemRow) => DataRow(
                      cells: [
                        DataCell(
                          Text(itemRow.subjects),
                        ),
                        DataCell(
                          Text('${itemRow.total}'),
                        ),
                        DataCell(
                          Text('${itemRow.marks}'),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                'Percentage: ' + "90" + "%",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ItemInfo {
  String subjects;
  int marks;
  int total;

  ItemInfo({this.subjects, this.marks, this.total});
}

var items = <ItemInfo>[
  ItemInfo(subjects: 'English', marks: 100, total: 100),
  ItemInfo(subjects: 'IP', marks: 90, total: 100),
  ItemInfo(subjects: 'Maths', marks: 80, total: 100),
  ItemInfo(subjects: 'Chemistry', marks: 70, total: 100),
  ItemInfo(subjects: 'Physics', marks: 80, total: 100),
];
