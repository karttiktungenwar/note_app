part of 'login_auth_bloc.dart';

sealed class LoginAuthEvent {}

class GetLoginAuthEvent extends LoginAuthEvent{
  LoginAuthEntityReq req;
  GetLoginAuthEvent({required this.req});
}

class LogoutEvent extends LoginAuthEvent{
  LogoutEvent();
}

class GetLoginAuthTokenEvent extends LoginAuthEvent{
  GetLoginAuthTokenEvent();
}

class SaveLoginAuthTokenEvent extends LoginAuthEvent{
  String token;
  SaveLoginAuthTokenEvent({required this.token});
}