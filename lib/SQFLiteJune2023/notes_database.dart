import 'package:flutter_sqflite_database/SQFLiteJune2023/Pages/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  // Create Private Constructor
  NotesDatabase._init();

  //  create instance
  static final NotesDatabase instance = NotesDatabase._init();

  // DateBase
  Database? _database;

  // get DataBae
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/$filePath';
    // final path = join(dbPath, filePath);

    // open Database
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
    );
  }

  // create new DataBase
  Future<void> _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    const boolType = "BOOLEAN NOT NULL";
    const integerType = "INTEGER NOT NULL";
    await db.execute("""
    CREATE TABLE $tableNotes (
      ${NoteFields.id} $idType,
      ${NoteFields.isImportant} $boolType,
      ${NoteFields.number} $integerType,
      ${NoteFields.title} $textType,
      ${NoteFields.description} $textType,
      ${NoteFields.time} $textType
    )      
    """);
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;

    final id = await db.insert(
      tableNotes,
      note.toJson(),
    );

    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: "${NoteFields.id} = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    const orderBy = "${NoteFields.time} ASC"; // -> Extra for get time wise data
    // final result = await db.rawQuery("SELECT * FROM $tableNotes ORDER BY $orderBy");
    // -> same as below result
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((e) => Note.fromJson(e)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return await db.update(
      tableNotes,
      note.toJson(),
      where: "${NoteFields.id} = ?",
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableNotes,
      where: "${NoteFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
