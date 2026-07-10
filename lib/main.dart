import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:noteapp/src/app/di/injection_container.dart' as di;
import 'package:noteapp/src/core/constants/app_assets.dart';
import 'package:noteapp/src/core/enums/status.dart';
import 'package:noteapp/src/features/login/presentation/bloc/login_auth_bloc.dart';
import 'package:noteapp/src/features/login/presentation/screens/login_screen.dart';
import 'package:noteapp/src/features/notes/presentation/bloc/note_bloc.dart';
import 'package:noteapp/src/features/notes/presentation/screens/notes_page.dart';

void main() async {
  // Initialize Flutter binding
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve the splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize dependencies
  await di.init();

  // Remove the splash screen
  FlutterNativeSplash.remove();

  // Run the app
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Initialize LoginAuthBloc and dispatch GetLoginAuthTokenEvent
        BlocProvider(
          create: (_) => di.sl<LoginAuthBloc>()..add(GetLoginAuthTokenEvent()),
        ),
        BlocProvider(create: (_) => di.sl<NoteBloc>()),
      ],
      child: MaterialApp(
        title: 'Note App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        // Use BlocBuilder to listen to LoginAuthBloc and determine the home screen
        home: BlocBuilder<LoginAuthBloc, LoginAuthState>(
          builder: (context, state) {
            // Show loading image while token is being fetched
            if (state.getTokenStatus == Status.loading) {
              return Scaffold(
                backgroundColor: Colors.white, // Full-screen white background
                body: Center(
                  child: Image.asset(
                    AppAssets.appLogo, // Replace with your image path
                    width: 200,
                    height: 200,
                  ),
                ),
              );
            }
            // If the token is available in the state, route to NotesPage
            if (state.getTokenStatus == Status.success && state.token != null && state.token!.isNotEmpty) {
              return const NotesPage();
            }
            if(state.getTokenStatus == Status.error) {
              return const LoginScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}