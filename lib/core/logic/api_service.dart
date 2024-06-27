import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quick_log/quick_log.dart';

const log = Logger("");

class ApiService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: "https://fakestoreapi.com/",
      receiveDataWhenStatusError: true,
    ),
  );

  ApiService() {
    addInterceptors();
  }

  void addInterceptors() {
    _dio.interceptors.add(CustomApiInterceptor());
  }

  Future<CustomResponse> getFromServer({
    required String url,
    Map<String, dynamic>? params,
  }) async {
    if (params != null) {
      params.removeWhere(
          (key, value) => params[key] == null || params[key] == "");
    }
    try {
      if (url.isNotEmpty) {
        Response response = await _dio.get(
          url.startsWith("http") ? url : url,
          options: Options(headers: {
            "Accept": "application/json",
            "Accept-Language": "en",
            "lang": "en",
          }),
          queryParameters: params,
        );
        return CustomResponse(
          success: true,
          statusCode: 200,
          msg: "",
          response: response,
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
        return CustomResponse(
          success: true,
          statusCode: 200,
        );
      }
    } on DioException catch (err) {
      return handleServerError(err);
    }
  }

  CustomResponse handleServerError(DioException err) {
    if (err.type == DioExceptionType.badResponse) {
      if (err.response!.data.toString().contains("DOCTYPE") ||
          err.response!.data.toString().contains("<script>") ||
          err.response!.data["exception"] != null) {
        return CustomResponse(
          errType: 2,
          statusCode: err.response!.statusCode ?? 500,
          msg: "Server Error",
        );
      }
      try {
        return CustomResponse(
          statusCode: err.response?.statusCode ?? 500,
          errType: 1,
          msg: (err.response!.data["errors"] as Map).values.first.first,
          response: err.response,
        );
      } catch (e) {
        return CustomResponse(
          statusCode: err.response?.statusCode ?? 500,
          errType: 1,
          msg: err.response?.data["message"],
          response: err.response,
        );
      }
    } else if (err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      log.error(err.response!.data);
      return CustomResponse(
        statusCode: err.response?.statusCode ?? 500,
        errType: 0,
        msg: "Time out error",
      );
    } else {
      if (err.response == null) {
        log.error(err.type, includeStackTrace: false);
        log.error(err.error, includeStackTrace: false);
        log.error(err.message, includeStackTrace: false);
        log.error(err.message, includeStackTrace: false);
        log.error(err.requestOptions.toString(), includeStackTrace: false);
        return CustomResponse(
          statusCode: 402,
          errType: 0,
          msg: "No Connection",
        );
      }

      return CustomResponse(
        statusCode: 402,
        errType: 2,
        success: false,
        msg: "Server Error",
      );
    }
  }
}

class CustomApiInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print(err.stackTrace);
      printResponse(err.response!);
      log.error((err.response!.data ?? "").toString());
    }
    return super.onError(err, handler);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    if (kDebugMode && Platform.isAndroid) {
      printResponse(response);
    }
    return super.onResponse(response, handler);
  }
}

void printResponse(Response response) {
  log.warning(
      "---------------------Start Of Request Details ---------------------------");
  log.warning(
      "\x1B[31m(${response.requestOptions.method}) ( ${response.requestOptions.baseUrl + response.requestOptions.path} )");
  log.info("\x1B[50m( Headers )\x1B[0m");
  if (response.requestOptions.headers.isNotEmpty) {
    response.requestOptions.headers.forEach((key, value) {
      log.info("\x1B[15m$key : $value\x1B[0m");
    });
  } else {
    log.info("\x1B[15mNo Headers\x1B[0m");
  }
  if (response.requestOptions.method == "GET") {
    log.fine("\x1B[15m( Query Parameters )\x1B");
    if (response.requestOptions.queryParameters.isNotEmpty) {
      response.requestOptions.queryParameters.forEach((key, value) {
        log.fine("\x1B[15m$key : $value\x1B[0m");
      });
    } else {
      log.fine("\x1B[15mNo Parameters\x1B[0m");
    }
  } else {
    log.fine("\x1B[15m( Data )\x1B");
    FormData data = response.requestOptions.data;
    if (data.fields.isNotEmpty) {
      for (var element in data.fields) {
        log.fine("\x1B[15m${element.key} : ${element.value}\x1B[0m");
      }
    } else {
      log.fine("\x1B[15mNo Data\x1B[0m");
    }
  }

  log.fine(
      "\x1B[15m--------------------- Response ---------------------------\x1B[0m");
  var resp = jsonEncode(response.data);
  log.fine(resp);

  log.debug(
      "---------------------End Of Request Details ---------------------------");
}

class CustomResponse {
  bool success;
  int? errType;
  String msg;
  int statusCode;
  Response? response;
  dynamic error;

  CustomResponse({
    this.success = false,
    this.errType = 0,
    this.msg = "",
    this.statusCode = 0,
    this.response,
    this.error,
  });
}
