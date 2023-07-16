// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_sqflite_database/SQFLiteJune2023/Widgets/note_form_widget.dart';
import 'package:flutter_sqflite_database/SQFLiteJune2023/notes_database.dart';
import 'note.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  const AddEditNotePage({Key? key, this.note}) : super(key: key);

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  //InitState
  @override
  void initState() {
    debugPrint('note -> ${widget.note?.toJson()}');
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? "";
    description = widget.note?.description ?? "";
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            isImportant: isImportant,
            number: number,
            title: title,
            description: description,
            onChangedImportant: (_) => setState(() => isImportant = _),
            onChangedNumber: (_) => setState(() => number = _),
            onChangedTitle: (_) => setState(() => title = _),
            onChangedDescription: (_) => setState(() => description = _),
          ),
        ),
      );
  Widget buildButton() {
    final isFormValid =
        title.trim().isNotEmpty && description.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: const Text("Save"),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }
      Navigator.pop(context);
    }
  }

  Future<void> updateNote() async {
    final note = Note(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
      createTime: DateTime.now(),
    );
    await NotesDatabase.instance.update(note);
  }

  Future<void> addNote() async {
    final note = Note(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
      createTime: DateTime.now(),
    );
    await NotesDatabase.instance.create(note);
  }
}
