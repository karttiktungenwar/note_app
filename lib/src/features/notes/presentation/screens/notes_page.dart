import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/src/core/enums/status.dart';
import 'package:noteapp/src/core/extensions/build_context_extension.dart';
import 'package:noteapp/src/features/login/presentation/bloc/login_auth_bloc.dart';
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

  void logout() {
   context.pushAndRemoveUntil(LoginScreen());
}

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
          onPressed: () => {
            context.showConfirmationDialog(message: "Are Sure you want to logout",
                onYes: () => {
                  BlocProvider.of<LoginAuthBloc>(context).add(LogoutEvent())
              }
            )
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: MultiBlocListener(
        listeners: [
          // Listen to LoginAuthBloc for token changes
          BlocListener<LoginAuthBloc, LoginAuthState>(
            listener: (context, state) {
              if (state.logoutStatus == Status.success) {
                logout();
              }
            },
          ),
        ],
        child: BlocBuilder<NoteBloc, NoteState>(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          context.push(NoteForm())
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}