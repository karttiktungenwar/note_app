import 'package:dartz/dartz.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/login/domain/repository/login_auth_repository.dart';

class LoginAuthSaveTokenUsecase {
  final LoginAuthRepository loginAuthRepository;
  LoginAuthSaveTokenUsecase({ required this.loginAuthRepository});

  Future<Either<Failure, Unit>> saveToken({required String token}) async{
    return await loginAuthRepository.saveToken(token);
  }
}