import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/src/app/di/injection_container.dart';
import 'package:noteapp/src/app/di/injection_container.dart' as di;
import 'package:noteapp/src/features/login/presentation/bloc/login_auth_bloc.dart';
import 'package:noteapp/src/features/login/presentation/screens/login_screen.dart';
import 'package:noteapp/src/features/notes/presentation/bloc/note_bloc.dart';
import 'package:noteapp/src/features/notes/presentation/screens/notes_page.dart';

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
        BlocProvider(create: (_) => di.sl<LoginAuthBloc>()),
        BlocProvider(create: (_) => di.sl<NoteBloc>()),
      ],
      child: MaterialApp(
        title: 'Note App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginScreen(),
      ),
    );
  }


}
