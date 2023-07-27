import 'package:flutter/foundation.dart';
import 'package:flutter_sqflite_database/SQFLiteJuly2023/grocery_class.dart';
import 'package:sqflite/sqflite.dart';

class GroceryDatabase {
  // Singleton Instance
  GroceryDatabase._privateConstructor();
  // GroceryDatabase._init(); // => You can use this also
  // Instance
  static final GroceryDatabase instance = GroceryDatabase._privateConstructor();

  // DateBase
  Database? _database;

  // GetDatabase Instance

  Future<Database> get database async => _database ??= await _initDatabase();

  // InitDataBase

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = "$dbPath/groceries.db";

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // TableName
  final String _tableName = "groceries";

  // Create NewTable => IF no have (first time open)
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
     CREATE TABLE $_tableName(
               id INTEGER PRIMARY KEY AUTOINCREMENT, 
               name TEXT NOT NULL
                )
          ''');
  }

  // GET ALL GROCERIES
  Future<List<GroceryClass>> getGroceries() async {
    final db = await instance.database;
    final groceries = await db.query(
      _tableName,
      // orderBy: 'name', // Extra
    );

    return List<GroceryClass>.from(
      groceries.map(
        (e) => GroceryClass.fromJson(e),
      ),
    );
  }

  // Add/Create
  Future<int> createGrocery(GroceryClass grocery) async {
    final db = await instance.database;
    return db.insert(_tableName, grocery.toJson());
  }

  // Remove/Delete
  Future<int> removeGrocery(int id) async {
    final db = await instance.database;
    return await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Update/Edit Grocery

  Future<int> updateGrocery(GroceryClass grocery) async {
    debugPrint('updateGrocery => ${grocery.toJson()}');
    final db = await instance.database;
    return await db.update(
      _tableName,
      grocery.toJson(),
      where: "id = ?",
      whereArgs: [grocery.id],
    );
  }

  // get single grocery

  Future<GroceryClass?> singleGrocery(int id) async {
    final db = await instance.database;

    final grocery = await db.query(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
    );

    if (grocery.isNotEmpty) {
      return GroceryClass.fromJson(grocery.first);
    }
    return null;
  }
}
