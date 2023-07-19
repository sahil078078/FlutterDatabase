import 'package:flutter/material.dart';

class CreateUpdateGroceryPopup extends StatefulWidget {
  const CreateUpdateGroceryPopup({Key? key}) : super(key: key);

  @override
  State<CreateUpdateGroceryPopup> createState() =>
      _CreateUpdateGroceryPopupState();
}

class _CreateUpdateGroceryPopupState extends State<CreateUpdateGroceryPopup> {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(useMaterial3: true),
      child: AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add New Grocery",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        actions: [
          ActionChip(
            label: const Text("Cancel"),
            disabledColor: Colors.orange,
            visualDensity: VisualDensity.compact,
            onPressed: () => Navigator.pop(context),
          ),
          ActionChip(
            label: const Text("Save"),
            disabledColor: Colors.orange,
            visualDensity: VisualDensity.compact,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
