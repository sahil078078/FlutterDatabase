import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '29AugustHibeDBWithModel/transaction_pade.dart';
import '29AugustHibeDBWithModel/models/transaction.dart';

Future<void> main() async {
  // avoid an error
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // initialization hive
  Hive.registerAdapter(MyTransactionAdapter()); // register adapter
  await Hive.openBox('shopping_box'); // openBox
  await Hive.openBox<MyTransaction>('transactions'); // openbox
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Hive Expense App';
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TransactionPage(),
    );
  }
}
