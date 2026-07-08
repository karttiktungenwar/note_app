import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/src/app/di/injection_container.dart';
import 'package:noteapp/src/core/constants/app_constants.dart';
import 'package:noteapp/src/core/local_storage/secure_storage_service.dart';
import 'package:noteapp/src/features/login/presentation/screens/login_screen.dart';
import 'package:noteapp/src/features/notes/presentation/bloc/note_bloc.dart';
import 'package:noteapp/src/features/notes/presentation/widgets/note_form.dart';
import 'package:noteapp/src/features/notes/presentation/widgets/note_list.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final ValueNotifier<bool> _isSearching = ValueNotifier(false);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteBloc>().add(LoadNotes());
    });
  }

  @override
  void dispose() {
    _isSearching.dispose();
    _searchController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: ValueListenableBuilder<bool>(
        valueListenable: _isSearching,
        builder: (context, searching, _) {
          if (!searching) return const Text('Notes');

          return TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search notes...',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            style: const TextStyle(color: Colors.black),
            onChanged: (value) {
              context.read<NoteBloc>().add(SearchNotes(value.trim()));
            },
          );
        },
      ),
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: _isSearching,
          builder: (context, searching, _) {
            return IconButton(
              icon: Icon(searching ? Icons.close : Icons.search),
              onPressed: () {
                if (searching) {
                  _searchController.clear();
                  context.read<NoteBloc>().add(SearchNotes(''));
                }
                _isSearching.value = !searching;
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () {
            // 2. Clear the token and navigation history and send them back to LoginScreen
            sl<SecureStorageService>().clearAll();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false, // This removes all previous screens from the stack
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NoteLoaded) {
            return NoteList(notes: state.notes);
          }

          if (state is NoteError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('No notes found'));
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