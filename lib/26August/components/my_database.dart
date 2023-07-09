import 'package:flutter_sqflite_database/26August/components/hero.dart';
import 'package:sqflite/sqflite.dart';

class MyDataBase {
  static Database? database;

  //initialize database
  static Future<Database> initDatabase() async {
    database = await openDatabase(
      // Ensure the path is correctly for any platform
      ("${await getDatabasesPath()}hero_database.db"),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE HEROS("
            "id INTEGER PRIMARY KEY,"
            "name TEXT,"
            "age INTEGER,"
            "ability TEXT"
            ")");
      },

      // Version
      version: 1,
    );

    return database!;
  }

  // check database connected

  static Future<Database> getDatabaseConnect() async {
    if (database != null) {
      return database!;
    } else {
      return await initDatabase();
    }
  }

  // show all data

  static Future<List<SuperHero>> showAllData() async {
    final Database db = await getDatabaseConnect();
    final List<Map<String, dynamic>> maps = await db.query("HEROS");

    return List.generate(maps.length, (index) {
      return SuperHero(
        id: maps.elementAt(index)['id'],
        name: maps.elementAt(index)['name'],
        age: maps.elementAt(index)['age'],
        ability: maps.elementAt(index)['ability'],
      );
    });
  }

  // insert
}
