import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:noteapp/src/app/di/injection_container.dart';
import 'package:noteapp/src/app/di/injection_container.dart' as di;
import 'package:noteapp/src/core/constants/app_constants.dart';
import 'package:noteapp/src/core/local_storage/secure_storage_service.dart';
import 'package:noteapp/src/features/login/presentation/bloc/login_auth_bloc.dart';
import 'package:noteapp/src/features/login/presentation/screens/login_screen.dart';
import 'package:noteapp/src/features/notes/presentation/bloc/note_bloc.dart';
import 'package:noteapp/src/features/notes/presentation/screens/notes_page.dart';

void main() async {
  // 1. Initialize the binding
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // 2. Preserve the native splash screen so it doesn't turn black
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 3. Run your async initialization tasks
  await init();
  final storage = sl<SecureStorageService>();
  final token = await storage.readString(AppConstants.tokenKey);

  // 4. Remove the splash screen right before running the app
  FlutterNativeSplash.remove();
  runApp(NoteApp(token: token));
}

class NoteApp extends StatelessWidget {
  final String? token;

// Constructor now correctly accepts the token
  const NoteApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<LoginAuthBloc>()),
        BlocProvider(create: (_) => di.sl<NoteBloc>()),
      ],
      child: MaterialApp(
        title: 'Note App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
// If token exists, send them straight to the main app screen; otherwise, login.
        home: token != null && token!.isNotEmpty
            ? const NotesPage() // Replace with your actual home/notes screen
            : const LoginScreen(),
      ),
    );
  }
}
