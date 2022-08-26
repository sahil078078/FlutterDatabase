import 'package:flutter/material.dart';
import '26August/sqflite_home.dart';

void main() {
  // avoid an error
  WidgetsFlutterBinding.ensureInitialized;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SqfliteHomeScreen(),
    );
  }
}
