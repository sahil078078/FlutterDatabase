import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sqflite_database/SQFLiteJune2023/Pages/notes_page.dart';
import 'package:hive_flutter/adapters.dart';
import '02SeptemberFirebasePushNotification/firebase_push_notification_home.dart';
import '29AugHiveDBAndApiResponse/models/apidata.dart';
import '29AugustHibeDBWithModel/models/transaction.dart';

const String settingsBox = 'settings';
const String apiBox = 'ApisBoxies';
Future<void> main() async {
  // avoid an error
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

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
      theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.blueGrey.shade900,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          )),
      home: const NotesPage(),
    );
  }
}
