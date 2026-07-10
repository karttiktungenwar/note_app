import 'package:noteapp/src/core/error/exceptions.dart';
import 'package:noteapp/src/core/logger/logger.dart';
import 'package:noteapp/src/core/network/api_service.dart';
import 'package:noteapp/src/core/network/network_constants.dart';
import 'package:noteapp/src/features/login/data/model/request/login_auth_model_req.dart';
import 'package:noteapp/src/features/login/data/model/response/login_auth_model_resp.dart';

abstract class LoginAuthRemoteDataSource {
  Future<LoginAuthModelResp> getLoginAuth({required LoginAuthModelReq req});
}

class LoginAuthRemoteDataSourceImpl
    with Logger
    implements LoginAuthRemoteDataSource {
  final ApiService apiService;

  LoginAuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<LoginAuthModelResp> getLoginAuth({
    required LoginAuthModelReq req,
  }) async {
    try {
      final response = await apiService.post<Map<String, dynamic>>(
        path: NetworkConstants.loginAuth,
        body: req,
        headers: {'x-api-key': NetworkConstants.apiKey},
      );

      final token = response['token'] as String?;
      final message = response['error'] as String?;

      if (token != null) {
        apiRequestLog(
          body: response,
          uri: Uri.parse(NetworkConstants.loginAuth),
        );
        return LoginAuthModelResp.fromJson(response);
      }

      throw ServerException(message: message ?? 'Login failed');
    } on ServerException catch (e) {
      errorLog('LOGIN ERROR: $e');
      rethrow;
    } catch (e) {
      errorLog('LOGIN ERROR: $e');
      throw ServerException(message: e.toString());
    }
  }
}
