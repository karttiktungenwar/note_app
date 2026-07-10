import 'package:dartz/dartz.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/login/domain/repository/login_auth_repository.dart';

class LoginAuthGetTokenUsecase {
  final LoginAuthRepository loginAuthRepository;
  LoginAuthGetTokenUsecase({ required this.loginAuthRepository});

  Future<Either<Failure, String?>> getToken() async{
    return await loginAuthRepository.getToken();
  }
}