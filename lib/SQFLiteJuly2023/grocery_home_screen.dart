import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sqflite_database/SQFLiteJuly2023/create_update_grocery_popup.dart';
import 'package:flutter_sqflite_database/SQFLiteJuly2023/grocery_class.dart';

import 'grocery_database.dart';

class GroceryHomeScreen extends StatefulWidget {
  const GroceryHomeScreen({Key? key}) : super(key: key);

  @override
  State<GroceryHomeScreen> createState() => _GroceryHomeScreenState();
}

class _GroceryHomeScreenState extends State<GroceryHomeScreen> {
  final database = GroceryDatabase.instance;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(useMaterial3: true),
      child: Scaffold(
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
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => const CreateUpdateGroceryPopup(),
                  );

                  // For refresh
                  setState(() {});
                },
                icon: const Icon(Icons.local_grocery_store),
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: database.getGroceries(),
          builder: (context, AsyncSnapshot<List<GroceryClass>> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data == null || snapshot.data!.isEmpty
                  ? const Center(
                      child: Text(
                        "Grocery Empty\nAdd Groceries",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final grocery = snapshot.data!.elementAt(index);
                        return ListTile(
                          isThreeLine: false,
                          dense: true,
                          contentPadding: const EdgeInsets.only(
                            left: 20,
                            right: 10,
                          ),
                          visualDensity: VisualDensity.compact,
                          title: Text(
                            grocery.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            "Unique ID : ${grocery.id}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        CreateUpdateGroceryPopup(
                                      id: grocery.id,
                                    ),
                                  );

                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await database.removeGrocery(grocery.id!);
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.delete,
                                  size: 18,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
            } else if (snapshot.hasError) {
              return throw Exception("Error : ${snapshot.error}");
            } else {
              return const Center(
                child: CupertinoActivityIndicator(
                  color: Colors.brown,
                  animating: true,
                  radius: 20,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
