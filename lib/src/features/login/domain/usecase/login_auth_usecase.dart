import 'package:dartz/dartz.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/login/domain/entity/request/login_auth_entity_req.dart';
import 'package:noteapp/src/features/login/domain/entity/response/login_auth_entity_resp.dart';
import 'package:noteapp/src/features/login/domain/repository/login_auth_respository.dart';

class LoginAuthUsecase {
  final LoginAuthRepository loginAuthRepository;
  LoginAuthUsecase({required this.loginAuthRepository});

  Future<Either<Failure, LoginAuthEntityResp>> getLoginAuth({required LoginAuthEntityReq req}) async{
    return await loginAuthRepository.getLoginAuth(req: req);
  }
}