import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sqflite_database/SQFLiteJuly2023/create_update_grocery_popup.dart';

class GroceryHomeScreen extends StatefulWidget {
  const GroceryHomeScreen({Key? key}) : super(key: key);

  @override
  State<GroceryHomeScreen> createState() => _GroceryHomeScreenState();
}

class _GroceryHomeScreenState extends State<GroceryHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Colors.brown,
        title: const Text("Grocery"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CreateUpdateGroceryPopup(),
                );
              },
              icon: const Icon(Icons.local_grocery_store),
            ),
          ),
        ],
      ),
    );
  }
}
