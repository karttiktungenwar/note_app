part of 'login_auth_bloc.dart';

class LoginAuthState extends Equatable {
  final Failure? failure;
  final LoginAuthEntityResp? loginAuthEntityResp;
  final Status status;

  const LoginAuthState({
    this.failure,
    this.loginAuthEntityResp,
    required this.status,
  });

  LoginAuthState copyWith({
    Failure? failure,
    LoginAuthEntityResp? loginAuthEntityResp,
    Status? status,
  }) {
    return LoginAuthState(
      failure: failure ?? this.failure,
      loginAuthEntityResp: loginAuthEntityResp ?? this.loginAuthEntityResp,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    failure,
    loginAuthEntityResp,
    status,
  ];
}