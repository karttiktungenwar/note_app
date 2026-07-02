import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/src/core/database/app_database.dart';
import 'package:noteapp/src/app/di/injection_container.dart';
import 'package:noteapp/src/features/presentation/bloc/note_bloc.dart';
import 'package:noteapp/src/features/presentation/widgets/note_form.dart';
import 'package:noteapp/src/features/presentation/widgets/note_list.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<NoteBloc>(context).add(LoadNotes());
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is NoteLoaded) {
            return NoteList(notes: state.notes);
          }

          if (state is NoteError) {
            return Center(
              child: Text(state.message),
            );
          }

          return const Center(
            child: Text('No notes found'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NoteForm()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}