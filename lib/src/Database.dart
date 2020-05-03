import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'SpendingModel.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "spendingsDatabase.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Spendings ("
        "id INTEGER PRIMARY KEY,"
        "item TEXT,"
        "price REAL,"
        "date INTEGER"
        ")");
      });
  }

  Future<List<Spending>> getAllSpendings() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Spendings ORDER BY date DESC;");
    List<Spending> list = res.isNotEmpty ? res.map((c) => Spending.fromMap(c)).toList() : [];
    return list;
  }

  addSpending(Spending newSpending) async {
    final db = await database;
    return await db.rawInsert(
      "INSERT INTO Spendings (item, price, date)"
      "VALUES (?, ?, ?)",
      [newSpending.item, newSpending.price, newSpending.timestamp]
    );
  }

  deleteSpending(int id) async {
    final db = await database;
    return await db.rawDelete(
      "DELETE FROM Spendings WHERE id = ?",
      [id]
    );
  }

  updateSpending(Spending entry) async {
    final db = await database;
    return await db.rawUpdate(
      "UPDATE Spendings SET item = ?, price = ?, date = ? WHERE id = ?",
      [entry.item, entry.price, entry.timestamp, entry.id]
    );
  }
}