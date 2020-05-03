import 'package:flutter/material.dart';
import 'Database.dart';
import 'SpendingModel.dart';

class SpendingForm extends StatefulWidget {
  Spending spending;

  SpendingForm (Spending entry) {
    spending = entry;
  }

  @override
  _SpendingFormState createState() => _SpendingFormState(spending);
}

class _SpendingFormState extends State<SpendingForm> {
  final itemController = TextEditingController();
  final priceController = TextEditingController();
  DateTime selectedDate;
  TimeOfDay time;
  int id = -1;

  _SpendingFormState(Spending entry) {
    if (entry != null) {
      itemController.text = entry.item;
      priceController.text = entry.price.toString();
      selectedDate = DateTime.fromMillisecondsSinceEpoch(entry.timestamp);
      time = TimeOfDay.fromDateTime(selectedDate);
      id = entry.id;
    } else {
      selectedDate = DateTime.now();
      time = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    itemController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<Null> selectDate (BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2021)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<Null> selectTime (BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: time
    );

    if (picked != null && picked != time) {
      setState(() {
        time = picked;
      });
    }
  }

  void addSpendingToDatabase() async {
    await DBProvider.db.addSpending(Spending(
      item: itemController.text, 
      price: double.parse(priceController.text), 
      timestamp: DateTime(selectedDate.year, selectedDate.month, selectedDate.day, time.hour, time.minute).millisecondsSinceEpoch));
    Navigator.pop(context);
  }

  void updateSpendingInDatabase() async {
    await DBProvider.db.updateSpending(Spending(
      item: itemController.text, 
      price: double.parse(priceController.text), 
      timestamp: DateTime(selectedDate.year, selectedDate.month, selectedDate.day, time.hour, time.minute).millisecondsSinceEpoch,
      id: id));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create new entry"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            EditBox("Enter item", itemController),
            SizedBox(height: 10.0),
            EditBox("Enter price", priceController),    
            SizedBox(height: 10.0),
            ListTile(
              title: Text("${selectedDate.day}.${selectedDate.month}.${selectedDate.year}", textAlign: TextAlign.center),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: () => selectDate(context)
            ),
            ListTile(
              title: Text("${time.hour}:${time.minute}", textAlign: TextAlign.center),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: () => selectTime(context)
            ),
            RaisedButton(
              onPressed: id == -1 ? addSpendingToDatabase : updateSpendingInDatabase,
              child: Text(id == -1 ? "Add entry" : "Update entry")
            )
          ],
        )
      )
    );
  }
}

class EditBox extends TextField {
  EditBox(String text, TextEditingController controller) : super (
    decoration: InputDecoration(
      hintText: text
    ),
    textAlign: TextAlign.center,
    controller: controller
  );
}