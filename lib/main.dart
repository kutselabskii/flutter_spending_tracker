import 'package:flutter/material.dart';
import 'package:spending_tracker/src/EntriesPage.dart';
import 'package:spending_tracker/src/SpendingForm.dart';
import 'package:spending_tracker/src/PerMonth.dart';

void main() => runApp(SpendingTrackerApp());

class SpendingTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spending tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainPage(title: 'Spending tracker'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Create new entry'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SpendingForm(null)));
              }
            ),
            RaisedButton(
              child: Text('Entries'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EntriesPage()));
              }
            ),
            RaisedButton(
              child: Text('Spendings per month'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PerMonthPage()));
              }
            )
          ],
        ),
      ),
    );
  }
}
