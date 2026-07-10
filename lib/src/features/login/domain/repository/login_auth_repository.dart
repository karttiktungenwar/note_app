import 'package:dartz/dartz.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/login/domain/entity/request/login_auth_entity_req.dart';
import 'package:noteapp/src/features/login/domain/entity/response/login_auth_entity_resp.dart';

abstract class LoginAuthRepository {
  Future<Either<Failure, LoginAuthEntityResp>> getLoginAuth({required LoginAuthEntityReq req});
  Future<Either<Failure, Unit>> saveToken(String token);
  Future<Either<Failure,String?>> getToken();
  Future<Either<Failure, Unit>> logout();
}