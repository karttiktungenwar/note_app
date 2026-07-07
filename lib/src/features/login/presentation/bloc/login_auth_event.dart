part of 'login_auth_bloc.dart';

sealed class LoginAuthEvent {}

class GetLoginAuthEvent extends LoginAuthEvent{
  LoginAuthEntityReq req;
  GetLoginAuthEvent({required this.req});
}