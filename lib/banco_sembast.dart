import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

class Food {
  final int id;
  final String name;
  final double price;

  const Food({
    required this.id,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  static Food fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as double,
    );
  }

  @override
  String toString() {
    return 'Food{id: $id, name: $name, price: $price}';
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  late Database _db;
  final _store = intMapStoreFactory.store('foods');

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<void> open() async {
    final factory = databaseFactoryWeb;
    _db = await factory.openDatabase('my_app.db');

    // Inserir dados iniciais
    await _store.addAll(_db, [
      Food(id: 1, name: 'Apple', price: 1.50).toMap(),
      Food(id: 2, name: 'Banana', price: 0.75).toMap(),
      Food(id: 3, name: 'Orange', price: 1.20).toMap(),
    ]);
  }

  Future<void> insertFood(Food food) async {
    await _store.add(_db, food.toMap());
  }

  Future<List<Food>> foods() async {
    final records = await _store.find(_db);
    return records.map((record) {
      return Food.fromMap(record.value);
    }).toList();
  }
}
