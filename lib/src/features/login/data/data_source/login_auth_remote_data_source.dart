import 'package:noteapp/src/core/error/exceptions.dart';
import 'package:noteapp/src/core/logger/logger.dart';
import 'package:noteapp/src/core/network/api_service.dart';
import 'package:noteapp/src/core/network/network_constants.dart';
import 'package:noteapp/src/features/login/data/model/request/login_auth_model_req.dart';
import 'package:noteapp/src/features/login/data/model/response/login_auth_model_resp.dart';

import 'dart:developer';
import 'package:flutter/foundation.dart';


class LoginAuthRemoteDataSource with Logger{
  final ApiService apiService;
  LoginAuthRemoteDataSource({required this.apiService});

  Future<LoginAuthModelResp> getLoginAuth({
    required LoginAuthModelReq req,
  }) async {
    try {

      final response = await apiService.post<Map<String, dynamic>>(
        path: NetworkConstants.loginAuth,
        body: req.toJson(),
        headers: {'x-api-key': NetworkConstants.apiKey},
      );

      apiRequestLog(body: response, uri: Uri.parse(NetworkConstants.loginAuth));

      final token = response['token'] as String?;
      final message = response['error'] as String?;

      if (token != null) {
        return LoginAuthModelResp.fromJson(response);
      } else {
        throw ServerException(message: message.toString() ?? 'Login failed');
      }
    } catch (e) {
      log('LOGIN ERROR: $e');
      throw ServerException(message: e.toString());
    }
  }
}
