import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/src/features/domain/entity/note.dart';
import 'package:noteapp/src/features/presentation/bloc/note_bloc.dart';
import 'note_form.dart';


class NoteItem extends StatelessWidget {
  final Note note;

  const NoteItem({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(note.content),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => BlocProvider.of<NoteBloc>(context).add(DeleteExistingNote(note.id)),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NoteForm(note: note)),
        ),
      ),
    );
  }
}