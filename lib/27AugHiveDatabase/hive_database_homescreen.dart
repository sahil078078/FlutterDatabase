import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class HiveDatabaseHomescreen extends StatefulWidget {
  const HiveDatabaseHomescreen({Key? key}) : super(key: key);

  @override
  State<HiveDatabaseHomescreen> createState() => _HiveDatabaseHomescreenState();
}

class _HiveDatabaseHomescreenState extends State<HiveDatabaseHomescreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _items = [];
  final _shoppingBox = Hive.box('shopping_box');

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final data = _shoppingBox.keys.map((key) {
      final value = _shoppingBox.get(key);
      return {
        "key": key,
        "name": value["name"],
        "quantity": value["quantity"],
      };
    }).toList(growable: true);

    setState(() {
      _items = data.reversed.toList();
      // used reversed for get new apdate as first
    });
  }

  // create new item
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _shoppingBox.add(newItem);
    _refreshItems();
  }

  // Retrieve a single item from the database by using its key
  // this is not used still

  /*
  Map<String, dynamic> _readItem(int key) {
    final item = _shoppingBox.get(key);
    return item;
  }
  */

  // update a single item
  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _shoppingBox.put(itemKey, item);
    _refreshItems();
  }

  // delete a single item
  Future<void> _deleteItem(int itemKey) async {
    await _shoppingBox.delete(itemKey);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(milliseconds: 200),
        content: Text('An item has been delete'),
      ),
    );
  }

  // TextFieldController
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item

  void _showForm({required BuildContext context, int? itemKey}) async {
    // itemKey==null ==> create new item
    // itemKey!=null ==> update an existing item
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _quantityController.text = existingItem['quantity'];
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      elevation: 1.5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 10,
          right: 10,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Fruit/Vagitable',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (name) {
                  if (name != null && name.isNotEmpty) return null;
                  return 'Please enter name';
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (qty) {
                  if (qty != null && qty.isNotEmpty) return null;
                  return 'Please enter quantity';
                },
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orangeAccent),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orangeAccent),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // save new item
                          if (itemKey == null) {
                            _createItem({
                              'name': _nameController.text.trim(),
                              'quantity': _quantityController.text.trim(),
                            });
                          } else {
                            _updateItem(
                              itemKey,
                              {
                                'name': _nameController.text.trim(),
                                'quantity': _quantityController.text.trim(),
                              },
                            );
                          }
                          // after this clean un textField
                          _nameController.text = '';
                          _quantityController.text = '';

                          // after this close sheet
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(itemKey == null ? 'Create New' : 'Update'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        title: const Text(
          'HiveDB',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context: context),
        backgroundColor: Colors.black.withOpacity(0.52),
        child: const Icon(
          CupertinoIcons.add,
          size: 25,
        ),
      ),
      body: _items.isNotEmpty
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final curruntItem = _items.elementAt(index);
                return Padding(
                  padding: EdgeInsets.only(top: index == 0 ? 3 : 0),
                  child: Card(
                    color: Colors.orangeAccent,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    elevation: 1.5,
                    child: ListTile(
                      title: Text(
                        curruntItem['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        curruntItem['quantity'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _showForm(
                              context: context,
                              itemKey: curruntItem['key'],
                            ),
                            icon: const Icon(
                              CupertinoIcons.pen,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _deleteItem(curruntItem['key']),
                            icon: const Icon(
                              CupertinoIcons.delete,
                              color: Colors.white,
                              size: 22,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Center(
              child: Text(
                'No Data Found',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.28),
                ),
              ),
            ),
    );
  }
}
