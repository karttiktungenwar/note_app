import 'dart:convert';
import 'package:flutter/foundation.dart';

mixin Logger {
  final String _noneNSI = '\x1b[0m';
  final String _urlNSI = '\x1b[34;1;3m';

  String get _fileName {
    try {
      StackTrace stackTrace = StackTrace.current;
      String s = stackTrace.toString().split('\n')[2].split('(')[1];
      return s.substring(0, s.length - 1);
    } catch (_) {
      return 'Not Found!';
    }
  }

  void _beautyColoredJson(Map<String, dynamic> json, String ansiColorCode) {
    String beautyJson = const JsonEncoder.withIndent('\t').convert(json);
    for (String line in beautyJson.split('\n')) {
      debugPrint('$ansiColorCode $line$_noneNSI');
    }
  }

  void apiRequestLog({
    required Uri uri,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
  }) {
    if (kDebugMode) {
      String nsi = '\x1b[36;1;3m';
      debugPrint(
        '$nsi ================= API REQUEST =================$_noneNSI',
      );
      String time = DateTime.now().toString();
      debugPrint("$nsi TIME:$time$_noneNSI");
      debugPrint("$nsi LOCATION: $_fileName$_noneNSI");
      debugPrint(
        '$nsi -----------------------------------------------$_noneNSI',
      );
      debugPrint("$nsi URI: $_urlNSI$uri$_noneNSI");
      if (headers != null && headers.isNotEmpty) {
        debugPrint('$nsi HEADER:$_noneNSI');
        _beautyColoredJson(headers, nsi);
      }
      if (body != null && body.isNotEmpty) {
        debugPrint('$nsi BODY:$_noneNSI');
        _beautyColoredJson(body, nsi);
      }
      debugPrint(
        '$nsi ===============================================$_noneNSI',
      );
    }
  }

  void apiResponseLog({
    required String url,
    required int statusCode,
    Map<String, dynamic>? response,
  }) {
    if (kDebugMode) {
      String nsi = '\x1b[32;1;3m';
      debugPrint(
        '$nsi ================= API RESPONSE =================$_noneNSI',
      );
      String time = DateTime.now().toString();
      debugPrint("$nsi TIME:$time$_noneNSI");
      debugPrint("$nsi LOCATION: $_fileName$_noneNSI");
      debugPrint(
        '$nsi -----------------------------------------------$_noneNSI',
      );
      debugPrint("$nsi API: $_urlNSI$url$_noneNSI");
      debugPrint("$nsi STATUS CODE: $statusCode$_noneNSI");

      if (response != null && response.isNotEmpty) {
        debugPrint('$nsi RESPONSE:$_noneNSI');
        _beautyColoredJson(response, nsi);
      }
      debugPrint(
        '$nsi ===============================================$_noneNSI',
      );
    }
  }

  void errorLog(String message) {
    if (kDebugMode) {
      String nsi = '\x1b[31;1;3m';
      debugPrint(
        '$nsi ================== EXCEPTION ==================$_noneNSI',
      );
      String time = DateTime.now().toString();
      debugPrint("$nsi TIME:$time$_noneNSI");
      debugPrint("$nsi LOCATION: $_fileName$_noneNSI");
      debugPrint(
        '$nsi -----------------------------------------------$_noneNSI',
      );
      debugPrint("$nsi MESSAGE: $message$_noneNSI");
      debugPrint(
        '$nsi ===============================================$_noneNSI',
      );
    }
  }

  void processingLog(String message) {
    if (kDebugMode) {
      String nsi = '\x1b[35;1;3m';
      debugPrint(
        '$nsi ================== PROCESSING ==================$_noneNSI',
      );
      debugPrint("$nsi LOCATION: $_fileName$_noneNSI");
      debugPrint(
        '$nsi -----------------------------------------------$_noneNSI',
      );
      debugPrint("$nsi MESSAGE: $message$_noneNSI");
      debugPrint(
        '$nsi ===============================================$_noneNSI',
      );
    }
  }

  void routeUpdateLog(String routeName) {
    if (kDebugMode) {
      String nsi = '\x1b[33;1;3m';
      debugPrint(
        '$nsi ================== CHANGING ROUTE ==================$_noneNSI',
      );
      debugPrint("$nsi LOCATION: $_fileName$_noneNSI");
      debugPrint(
        '$nsi -----------------------------------------------$_noneNSI',
      );
      debugPrint("$nsi CURRENT ROUTE: $routeName$_noneNSI");
      debugPrint(
        '$nsi ===============================================$_noneNSI',
      );
    }
  }

  void successResultLog(String message) {
    if (kDebugMode) {
      String nsi = '\x1b[32;1;3m';
      debugPrint("$nsi LOCATION: $_fileName$_noneNSI");
      debugPrint(
        '$nsi -----------------------------------------------$_noneNSI',
      );
      debugPrint("$nsi$message$_noneNSI");
      debugPrint(
        '$nsi ===============================================$_noneNSI',
      );
    }
  }
}
