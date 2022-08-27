import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '27AugHiveDatabase/hive_database_homescreen.dart';

void main() async {
  // avoid an error
  WidgetsFlutterBinding.ensureInitialized;

  await Hive.initFlutter();
  await Hive.openBox('shopping_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HiveDatabaseHomeScreen(),
    );
  }
}
