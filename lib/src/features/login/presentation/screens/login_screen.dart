import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/src/app/di/injection_container.dart';
import 'package:noteapp/src/core/constants/app_assets.dart';
import 'package:noteapp/src/core/constants/app_constants.dart';
import 'package:noteapp/src/core/enums/status.dart';
import 'package:noteapp/src/core/extensions/build_context_extension.dart';
import 'package:noteapp/src/core/local_storage/secure_storage_service.dart';
import 'package:noteapp/src/features/login/domain/entity/request/login_auth_entity_req.dart';
import 'package:noteapp/src/features/login/presentation/bloc/login_auth_bloc.dart';
import 'package:noteapp/src/features/notes/presentation/screens/notes_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  void goToNotesPage() async {
    context.pushAndRemoveUntil(NotesPage());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginAuthBloc, LoginAuthState>(
          listenWhen: (previous, current) =>
          previous.status != current.status,
          listener: (context, state) {
            if (state.status == Status.success) {

              BlocProvider.of<LoginAuthBloc>(context).add(SaveLoginAuthTokenEvent(token: state.loginAuthEntityResp?.token ?? ''));
            } else if (state.status == Status.error) {
              context.showSnackBar(message: state.failure?.message ?? 'Login failed');
            }
          },
        ),
        BlocListener<LoginAuthBloc, LoginAuthState>(
          listenWhen: (previous, current) =>
          previous.saveTokenStatus != current.saveTokenStatus,
          listener: (context, state){
            if (state.status == Status.success) {
              context.showSnackBar(message: 'Login Successfully');
              goToNotesPage();
            } else if (state.status == Status.error) {
              context.showSnackBar(message: state.failure?.message ?? 'Login failed');
            }
          },
        )
      ],
      child: BlocBuilder<LoginAuthBloc, LoginAuthState>(
        builder: (context, state) {
        final isLoading = state.status == Status.loading;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            AppAssets.appLogo,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Note App',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Login to continue',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                          final req = LoginAuthEntityReq(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          context.read<LoginAuthBloc>().add(
                            GetLoginAuthEvent(req: req),
                          );
                        },
                        child: isLoading
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    )
    );
  }
}