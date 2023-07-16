import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  const NoteFormWidget({
    Key? key,
    this.isImportant = false,
    this.number = 0,
    this.title = "",
    this.description = "",
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Switch(
                  value: isImportant ?? false,
                  onChanged: onChangedImportant,
                ),
                Expanded(
                  child: Slider(
                    inactiveColor: Colors.white,
                    divisions: 100,
                    label: "$number",
                    min: 0,
                    max: 100,
                    value: (number ?? 0).toDouble(),
                    onChanged: (_) => onChangedNumber(_.toInt()),
                  ),
                )
              ],
            ),
            buildTitle(),
            const SizedBox(height: 8),
            buildDescription(),
            const SizedBox(height: 8)
          ],
        ),
      ),
    );
  }

  Widget buildTitle() => TextFormField(
        maxLines: 5,
        initialValue: title,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Title",
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (title) => title != null && title.trim().isNotEmpty
            ? null
            : "Please enter title",
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        initialValue: description,
        style: const TextStyle(color: Colors.white60, fontSize: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (title) => title != null && title.trim().isNotEmpty
            ? null
            : "Please enter description",
        onChanged: onChangedDescription,
      );
}
