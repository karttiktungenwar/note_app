import 'package:noteapp/src/core/constants/app_constants.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/core/local_storage/secure_storage_service.dart';

abstract class LoginAuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> logout();
}

class LoginAuthLocalDataSourceImpl implements LoginAuthLocalDataSource{
  SecureStorageService secureStorageService;

  LoginAuthLocalDataSourceImpl({required this.secureStorageService});

  @override
  Future<String?> getToken() async {
    try{
      return await secureStorageService.readString(AppConstants.tokenKey);
    }catch(e){
      throw CacheFailure(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try{
      return await secureStorageService.clearAll();
    }catch(e){
      throw CacheFailure(message: e.toString());
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try{
      return await secureStorageService.writeString(AppConstants.tokenKey, token);
    }catch(e){
      throw CacheFailure(message: e.toString());
    }
  }

}