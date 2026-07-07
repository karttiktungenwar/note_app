import 'package:flutter/material.dart';
import 'package:noteapp/src/features/notes/domain/entity/note.dart';
import 'note_item.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;

  const NoteList({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) => NoteItem(note: notes[index]),
    );
  }
}