import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:noteapp/src/core/logger/logger.dart';

class CustomInterceptor extends Interceptor with Logger {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      apiRequestLog(
        uri: options.uri,
        body: options.data is String ? jsonDecode(options.data) : options.data,
        headers: options.headers,
      );
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is String) {
      final decodedData = jsonDecode(response.data);
      response.data = decodedData;
    }

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      errorLog(err.message ?? '');
    }
    handler.reject(err);
  }
}
