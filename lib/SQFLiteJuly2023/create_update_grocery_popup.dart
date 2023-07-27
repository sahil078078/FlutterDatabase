import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite_database/SQFLiteJuly2023/grocery_class.dart';
import 'package:flutter_sqflite_database/SQFLiteJuly2023/grocery_database.dart';

class CreateUpdateGroceryPopup extends StatefulWidget {
  final int? id;
  const CreateUpdateGroceryPopup({Key? key, this.id}) : super(key: key);

  @override
  State<CreateUpdateGroceryPopup> createState() =>
      _CreateUpdateGroceryPopupState();
}

class _CreateUpdateGroceryPopupState extends State<CreateUpdateGroceryPopup> {
  final textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final database = GroceryDatabase.instance;
  bool isUpdate = false;
  bool loading = false;

  @override
  void initState() {
    isUpdate = widget.id != null;
    if (widget.id != null) {
      _getSingleGrocery();
    }
    super.initState();
  }

  void _getSingleGrocery() async {
    setState(() => loading = true);
    final grocery = await database.singleGrocery(widget.id!);
    if (grocery != null) textController.text = grocery.name;
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(useMaterial3: true),
      child: AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        content: loading
            ? const SizedBox(
                height: 155,
                child: Center(
                  child: CupertinoActivityIndicator(
                    radius: 15,
                  ),
                ),
              )
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isUpdate ? "Update Grocery" : "Add New Grocery",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (_) {
                        if (_ != null && _.trim().isNotEmpty) return null;
                        return "Please enter grocery";
                      },
                    ),
                  ],
                ),
              ),
        actionsPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        actions: loading
            ? null
            : [
                ActionChip(
                  label: const Text("Cancel"),
                  disabledColor: Colors.orange,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Navigator.pop(context),
                ),
                ActionChip(
                  label: Text(isUpdate ? "Update" : "Save"),
                  disabledColor: Colors.orange,
                  visualDensity: VisualDensity.compact,
                  onPressed: () async {
                    final nav = Navigator.of(context);
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      final grocery = GroceryClass(
                        id: widget.id,
                        name: textController.text.trim(),
                      );

                      if (isUpdate) {
                        await database.updateGrocery(grocery);
                      } else {
                        await database.createGrocery(grocery);
                      }
                      if (mounted) nav.pop();
                    }
                  },
                )
              ],
      ),
    );
  }
}
