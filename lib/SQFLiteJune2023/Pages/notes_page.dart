import 'package:flutter/material.dart';
import 'package:flutter_sqflite_database/SQFLiteJune2023/Pages/add_edit_note_page.dart';

import '../Widgets/note_card_widget.dart';
import '../notes_database.dart';
import 'note.dart';
import 'note_details_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  Future<void> refreshNotes() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  //Dispose
  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notes",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: const <Widget>[Icon(Icons.search), SizedBox(width: 12)],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : notes.isEmpty
                ? const Text(
                    "No Notes found",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )
                : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditNotePage(),
            ),
          );

          refreshNotes();
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget buildNotes() => AlignedGridView.count(
        itemCount: notes.length,
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoteDetailPage(noteId: note.id!),
                ),
              );

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
