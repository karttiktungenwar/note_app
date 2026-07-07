import 'package:dartz/dartz.dart';
import 'package:noteapp/src/core/error/exceptions.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/login/data/data_source/login_auth_remote_data_source.dart';
import 'package:noteapp/src/features/login/data/model/request/login_auth_model_req.dart';
import 'package:noteapp/src/features/login/data/model/response/login_auth_model_resp.dart';
import 'package:noteapp/src/features/login/domain/entity/request/login_auth_entity_req.dart';
import 'package:noteapp/src/features/login/domain/entity/response/login_auth_entity_resp.dart';
import 'package:noteapp/src/features/login/domain/repository/login_auth_respository.dart';

class LoginAuthRepositoryImpl implements LoginAuthRepository {
  final LoginAuthRemoteDataSource loginAuthRemoteDataSource;

  LoginAuthRepositoryImpl({required this.loginAuthRemoteDataSource});

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

}