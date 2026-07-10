part of 'login_auth_bloc.dart';

class LoginAuthState extends Equatable {
  final Failure? failure;
  final String? successMessage;
  final String? token;
  final LoginAuthEntityResp? loginAuthEntityResp;
  final Status status;
  final Status logoutStatus;
  final Status getTokenStatus;
  final Status saveTokenStatus;

  const LoginAuthState({
    this.failure,
    this.successMessage,
    this.token,
    this.loginAuthEntityResp,
    this.status = Status.initial,
    this.logoutStatus = Status.initial,
    this.getTokenStatus = Status.initial,
    this.saveTokenStatus = Status.initial,
  });

  LoginAuthState copyWith({
    Failure? failure,
    String? successMessage,
    String? token,
    LoginAuthEntityResp? loginAuthEntityResp,
    Status? status,
    Status? logoutStatus,
    Status? getTokenStatus,
    Status? saveTokenStatus,
  }) {
    return LoginAuthState(
      failure: failure ?? this.failure,
      successMessage: successMessage ?? this.successMessage,
      token: token ?? this.token,
      loginAuthEntityResp: loginAuthEntityResp ?? this.loginAuthEntityResp,
      status: status ?? this.status,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      getTokenStatus: getTokenStatus ?? this.getTokenStatus,
      saveTokenStatus: saveTokenStatus ?? this.saveTokenStatus,
    );
  }

  @override
  List<Object?> get props => [
    failure,
    successMessage,
    token,
    loginAuthEntityResp,
    status,
    logoutStatus,
    getTokenStatus,
    saveTokenStatus,
  ];
}