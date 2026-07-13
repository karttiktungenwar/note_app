import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/src/core/constants/app_assets.dart';
import 'package:noteapp/src/core/enums/status.dart';
import 'package:noteapp/src/core/extensions/build_context_extension.dart';
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
  final _formKey = GlobalKey<FormState>();


  void goToNotesPage() {
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
              final token = state.loginAuthEntityResp?.token ?? '';
              if(token.isNotEmpty) {
                BlocProvider.of<LoginAuthBloc>(context).add(
                    SaveLoginAuthTokenEvent(token: token));
              }else{
                context.showSnackBar(message: 'Please try again Login failed');
              }
            } else if (state.status == Status.error) {
              context.showSnackBar(message: state.failure?.message ?? 'Please try again Login failed');
            }
          },
        ),
        BlocListener<LoginAuthBloc, LoginAuthState>(
          listenWhen: (previous, current) =>
          previous.saveTokenStatus != current.saveTokenStatus,
          listener: (context, state){
            if (state.saveTokenStatus == Status.success) {
              goToNotesPage();
              context.showSnackBar(message: 'Login Successfully');
            } else if (state.saveTokenStatus == Status.error) {
              context.showSnackBar(message: state.failure?.message ?? 'Please try again Login failed');
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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }
                              final email = value.trim();
                              // Simple email regex (good enough for most cases)
                              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
                              if (!emailRegex.hasMatch(email)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                // validate form first
                                if (_formKey.currentState?.validate() ?? false) {
                                  final req = LoginAuthEntityReq(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );

                                  context.read<LoginAuthBloc>().add(
                                    GetLoginAuthEvent(req: req),
                                  );
                                } else {
                                  // Optionally: focus the first invalid field, or show a snackbar.
                                }
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
                    )
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