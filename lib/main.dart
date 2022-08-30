import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '29AugHiveDBAndApiResponse/models/apidata.dart';
import '29AugustHibeDBWithModel/models/transaction.dart';
import '30AugustPAgginationExample/paggination_homepage.dart';

const String settingsBox = 'settings';
const String apiBox = 'ApisBoxies';
Future<void> main() async {
  // avoid an error
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // initialization hive
  Hive.registerAdapter(MyTransactionAdapter()); // register adapter
  Hive.registerAdapter(ApiDataAdapter());
  await Hive.openBox('shopping_box'); // openBox
  await Hive.openBox<MyTransaction>('transactions'); // openbox
  await Hive.openBox(settingsBox); // open new setting hive box
  await Hive.openBox(apiBox); // open new post box
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DataBase',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const PagginationHomePage(),
    );
  }
}
