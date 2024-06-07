//import 'dart:indexed_db';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Food {
  final int id;
  final String name;
  final double price;

  const Food({
  required this.id,
  required this.name,
  required this.price,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
  @override
  String toString() {
    return 'Food{id: $id, name: $name, price: $price}';
  }
}
// class Drink {
//   final int id;
//   final String name;
//   final double price;
//
//   Drink({required this.id, required this.name, required this.price});
// }
//
// class CartItem {
//   final int id;
//   final String itemName;
//   final double itemPrice;
//   final int quantity;
//
//   CartItem({
//     required this.id,
//     required this.itemName,
//     required this.itemPrice,
//     required this.quantity,
//   });
//
// }

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  late Database _db;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<void> open() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_app.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE foods (
            id INTEGER PRIMARY KEY,
            name TEXT,
            price REAL
          )
        ''');
      //   await db.execute('''
      //     CREATE TABLE drinks (
      //       id INTEGER PRIMARY KEY,
      //       name TEXT,
      //       price REAL
      //     )
      //   ''');
      //   await db.execute('''
      //     CREATE TABLE cart_items (
      //       id INTEGER PRIMARY KEY,
      //       item_name TEXT,
      //       item_price REAL,
      //       quantity INTEGER
      //     )
      //   ''');
      },
    );
  }

  Future<void> insertFood(Food food) async {
    await _db.insert('foods', food.toMap(),  conflictAlgorithm: ConflictAlgorithm.replace,);

  }
  Future<List<Food>> foods() async {
    // Get a reference to the database.
    final db = await _db;

    // Query the table for all the dogs.
    final List<Map<String, Object?>> foodMaps = await db.query('foods');

    // Convert the list of each dog's fields into a list of Dog objects.
    return [
      for (final {
      'id': id as int,
      'name': name as String,
      'price': price as double,
      } in foodMaps)
        Food(id: id, name: name, price: price),
    ];
  }

  // Future<void> insertDrink(Drink drink) async {
  //   await _db.insert('drinks', drink.toMap());
  // }
  //
  // Future<void> insertCartItem(CartItem cartItem) async {
  //   await _db.insert('cart_items', cartItem.toMap());
  // }
}
// var fido = Food(
//   id: 0,
//   name: 'Fidodido',
//   price: 35.90,
// );
//
// insertFood(fidodido)

