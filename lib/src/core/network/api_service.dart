import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:noteapp/src/core/error/exceptions.dart';

import 'custome_interceptor.dart';


abstract class ApiService {
  Future<T> get<T>({required String path, Map<String, dynamic>? queryParams});

  Future<T> post<T>({
    required String path,
    dynamic body,
    Map<String, dynamic>? headers,
  });

  Future<T> put<T>({required String path, Map<String, dynamic>? body});

  Future<T> delete<T>({required String path});

}

class ApiServiceImpl implements ApiService {
  final Dio _dio;

  ApiServiceImpl({required String baseUrl})
      : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
    ),
  ){
    _dio.interceptors.add(
      CustomInterceptor(),
    );
  }

  @override
  Future<T> get<T>({
    required String path,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParams);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data as T;
      } else {
        throw ServerException(
          message: response.statusMessage.toString() ?? 'Server Error',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: _getDioExceptionType(e),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<T> post<T>({
    required String path,
    dynamic body,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: jsonEncode(body),
        options: Options(headers: headers),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data as T;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Server Error',
        );
      }
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } on DioException catch (e) {
      throw ServerException(
        message: _getDioExceptionType(e),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<T> put<T>({required String path, Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.put(path, data: body);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data as T;
      } else {
        throw ServerException(
          message: response.statusMessage.toString() ?? 'Server Error',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: _getDioExceptionType(e),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<T> delete<T>({
    required String path,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _dio.delete(path, data: body);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data as T;
      } else {
        throw ServerException(
          message: response.statusMessage ?? 'Server Error',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: _getDioExceptionType(e),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

}

String _getDioExceptionType(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      return 'Connection timed out. Please try again.';
    case DioExceptionType.sendTimeout:
      return 'Unable to send data to the server.';
    case DioExceptionType.receiveTimeout:
      return 'Server is taking too long to respond.';
    case DioExceptionType.badCertificate:
      return 'Secure connection failed (Invalid Certificate).';
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      return 'Server error occurred (Status: $statusCode).';
    case DioExceptionType.cancel:
      return 'Request was cancelled.';
    case DioExceptionType.connectionError:
      return 'No internet connectivity. Kindly check and retry.';
    case DioExceptionType.unknown:
      return 'An unexpected error occurred. Please try again.';
    case DioExceptionType.transformTimeout:
      // TODO: Handle this case.
      throw UnimplementedError();
  }
}
