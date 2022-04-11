import 'package:flutter/material.dart';
import 'package:flutter_sqflite_database/11_4_2022/database_helper.dart';
import 'database_helper.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  final dbHelper = DatabaseHelper.instance;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _insert();
              },
              child: const Text('Insert'),
            ),
            ElevatedButton(
              onPressed: () {
                _query();
              },
              child: const Text('Query'),
            ),
            ElevatedButton(
              onPressed: () {
                _update;
              },
              child: const Text('Update'),
            )
          ],
        ),
      ),
    );
  }

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnAge: 23
    };

    final id = await dbHelper.insert(row);
    print(id);
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows');
    allRows.forEach((print));
  }

  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 23,
    };
    final rowsAffected = await dbHelper.update(row);
    print("update $rowsAffected row(s)");
  }
}
