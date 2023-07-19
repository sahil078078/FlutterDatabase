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
      orderBy: 'name', // Extra
    );

    return List<GroceryClass>.from(
      groceries.map(
        (e) => GroceryClass.fromJson(e),
      ),
    );
  }
} 
