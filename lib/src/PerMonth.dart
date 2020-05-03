import 'package:flutter/material.dart';

import 'SpendingModel.dart';
import 'Database.dart';

class PerMonthPage extends StatefulWidget {
  PerMonthPage({Key key}): super(key: key);

  @override
  _PerMonthPageState createState() => _PerMonthPageState();
}

class _PerMonthPageState extends State<PerMonthPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Spendings per month"),
      ),
      body: FutureBuilder<List<Spending>>(
        future: DBProvider.db.getAllSpendings(),
        builder: (BuildContext context, AsyncSnapshot<List<Spending>> snapshot) {
          if (snapshot.hasData) {
            Map<DateTime, double> perMonth = Map();
            for (Spending item in snapshot.data) {
              DateTime itemDate = DateTime.fromMillisecondsSinceEpoch(item.timestamp);
              DateTime key = DateTime(itemDate.year, itemDate.month);
              if (perMonth.containsKey(key)) {
                perMonth[key] += item.price;
              } else {
                perMonth[key] = item.price;
              }
            }
            List<Widget> widgets = List();
            for (DateTime key in perMonth.keys) {
              widgets.add(ListTile(
                leading: Text("${key.month}.${key.year}"),
                title: Text(perMonth[key].toString(), textAlign: TextAlign.center)
              ));
            }
            return ListView(children: widgets);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }
}