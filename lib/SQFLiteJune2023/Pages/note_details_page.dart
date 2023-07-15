// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_sqflite_database/SQFLiteJune2023/Pages/add_edit_note_page.dart';
import 'package:flutter_sqflite_database/SQFLiteJune2023/notes_database.dart';
import 'package:intl/intl.dart';

import 'note.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;
  const NoteDetailPage({Key? key, required this.noteId}) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;
  //InitState
  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future<void> refreshNote() async {
    setState(() => isLoading = true);
    note = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().format(note.createTime),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget editButton() => IconButton(
        icon: const Icon(Icons.edit_outlined),
        onPressed: () async {
          if (isLoading) return;

          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AddEditNotePage(note: note);
              },
            ),
          );

          refreshNote();
        },
      );

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          if (isLoading) return;
          await NotesDatabase.instance.delete(widget.noteId);
          Navigator.pop(context);
        },
      );
}
