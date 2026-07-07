import 'package:noteapp/src/features/login/domain/entity/request/login_auth_entity_req.dart';

class LoginAuthModelReq extends LoginAuthEntityReq {
  LoginAuthModelReq({
    required super.email,
    required super.password,
  });

  factory LoginAuthModelReq.fromJson(Map<String, dynamic> json) {
    return LoginAuthModelReq(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  factory LoginAuthModelReq.fromEntity(LoginAuthEntityReq entity) {
    return LoginAuthModelReq(
      email: entity.email,
      password: entity.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}