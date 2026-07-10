import 'package:dartz/dartz.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/login/domain/repository/login_auth_repository.dart';

class LogoutAuthUsecase {
  final LoginAuthRepository loginAuthRepository;
  LogoutAuthUsecase({ required this.loginAuthRepository});

  Future<Either<Failure, Unit>> logout() async{
    return await loginAuthRepository.logout();
  }
}