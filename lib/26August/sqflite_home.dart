import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sqflite_database/26August/components/my_database.dart';

import 'components/hero.dart';

class SqfliteHomeScreen extends StatelessWidget {
  SqfliteHomeScreen({Key? key}) : super(key: key);

  final batman = SuperHero(
    id: 0,
    name: "Batman",
    age: 50,
    ability: "Rich",
  );

  final supernam = SuperHero(
    id: 1,
    name: "Superman",
    age: 35,
    ability: "I can fly",
  );

  @override
  Widget build(BuildContext context) {
    final database = MyDataBase.showAllData();
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Colors.orangeAccent,
        elevation: 0.0,
      ),
      body: Builder(builder: (context) {
        return Center(
          child: TextButton(
            onPressed: () async {
              log(database.toString());
            },
            child: const Text('getdata'),
          ),
        );
      }),
    );
  }
}
