import 'dart:convert';

class Spending {
  int id;
  String item;
  double price;
  int timestamp;

  Spending({
    this.id,
    this.item,
    this.price,
    this.timestamp
  });

  factory Spending.fromMap(Map<String, dynamic> json) => new Spending(
    id: json["id"],
    item: json["item"],
    price: json["price"],
    timestamp: json["date"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "item": item,
    "price": price,
    "date": timestamp
  };
}