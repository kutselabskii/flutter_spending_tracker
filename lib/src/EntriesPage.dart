import 'package:flutter/material.dart';

import 'SpendingForm.dart';
import 'SpendingModel.dart';
import 'Database.dart';

class EntriesPage extends StatefulWidget {
  EntriesPage({Key key}): super(key: key);

  @override
  _EntriesPageState createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {

  void editEntry(Spending entry) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SpendingForm(entry)));
  }

  void deleteEntry(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete entry"),
          content: new Text("Do you really want to delete this entry?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                await DBProvider.db.deleteSpending(id);
                Navigator.of(context).pop();
                setState(() {});
              }
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              }
            )
          ]
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entries"),
      ),
      body: FutureBuilder<List<Spending>>(
        future: DBProvider.db.getAllSpendings(),
        builder: (BuildContext context, AsyncSnapshot<List<Spending>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Spending item = snapshot.data[index];
                DateTime date = DateTime.fromMillisecondsSinceEpoch(item.timestamp);
                String dateString = "${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute}";
                return ListTile(
                  title: Text(item.item),
                  leading: Text(item.price.toString()),
                  trailing: Text(dateString),
                  onTap: () => deleteEntry(item.id),
                  onLongPress: () => editEntry(item),
                );
              }
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }
}