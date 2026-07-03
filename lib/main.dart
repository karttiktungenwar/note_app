import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/src/app/di/injection_container.dart';
import 'package:noteapp/src/app/di/injection_container.dart' as di;
import 'package:noteapp/src/features/presentation/bloc/note_bloc.dart';
import 'package:noteapp/src/features/presentation/screens/notes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<NoteBloc>()),
      ],
      child: MaterialApp(
        title: 'Note App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const NotesPage(),
      ),
    );
  }


}
