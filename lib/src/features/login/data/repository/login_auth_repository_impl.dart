import 'package:dartz/dartz.dart';
import 'package:noteapp/src/core/error/exceptions.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/login/data/data_source/login_auth_local_data_source.dart';
import 'package:noteapp/src/features/login/data/data_source/login_auth_remote_data_source.dart';
import 'package:noteapp/src/features/login/data/model/request/login_auth_model_req.dart';
import 'package:noteapp/src/features/login/domain/entity/request/login_auth_entity_req.dart';
import 'package:noteapp/src/features/login/domain/entity/response/login_auth_entity_resp.dart';
import 'package:noteapp/src/features/login/domain/repository/login_auth_repository.dart';

class LoginAuthRepositoryImpl implements LoginAuthRepository {
  final LoginAuthRemoteDataSource loginAuthRemoteDataSource;
  final LoginAuthLocalDataSource loginAuthLocalDataSource;

  LoginAuthRepositoryImpl({
    required this.loginAuthRemoteDataSource,
    required this.loginAuthLocalDataSource,
  });

  @override
  Future<Either<Failure, LoginAuthEntityResp>> getLoginAuth({required LoginAuthEntityReq req}) async{
    try{
      final response = await loginAuthRemoteDataSource.getLoginAuth(
        req: LoginAuthModelReq.fromEntity(req),
      );
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (_) {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DefaultFailure());
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await loginAuthLocalDataSource.getToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveToken(String token) async {
    try {
      await loginAuthLocalDataSource.saveToken(token);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await loginAuthLocalDataSource.logout();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

}