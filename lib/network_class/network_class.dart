import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import '../../session_manager/session_manager.dart';
import '../api_constant/api_constant.dart';


// ignore: constant_identifier_names
enum Method { POST, GET, PUT, DELETE, PATCH }

class HttpService {
  HttpService()
      : _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.tokenBaseUrl,
      connectTimeout: 20000,
      receiveTimeout: 10000,
      responseType: ResponseType.json,
    ),
  );

  late final Dio _dio;

  var logger = Logger();

  static header() => {"Content-Type": "application/json"};

  void initInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (requestOptions, handler) {
          logger.i("REQUEST[${requestOptions.method}] => PATH: ${requestOptions.path}"
              "=> REQUEST VALUES: ${requestOptions.queryParameters} "
              "=> HEADERS: ${requestOptions.contentType}");
          SessionManager.getInstance().getToken().then((value) {
              debugPrint("<------token value------>$value");
              requestOptions.headers['Authorization'] = 'Bearer $value';
              return handler.next(requestOptions);
            },);
        },
        onResponse: (response, handler) {
          logger
              .i("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
          return handler.next(response);
        },
        onError: (err, handler) {
          logger.i("Error[${err.response?.statusCode}]");
          return handler.next(err);
        },
      ),
    );
  }

  Future<Response?> request({required String url, Method? method, dynamic params}) async {
    Response response;
    try {
      if (method == Method.POST) {
        response = await _dio.post(url, data: params);
      } else if (method == Method.DELETE) {
        response = await _dio.delete(url);
      } else if (method == Method.PATCH) {
        response = await _dio.patch(url);
      } else if (method == Method.PUT) {
        response = await _dio.put(url, data: params);
      } else if (method == Method.GET) {
        response = await _dio.get(url);
      } else {
        response = await _dio.get(url, queryParameters: params);
      }
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 400) {
        debugPrint("Invalid credential");
        throw "Invalid credential";
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized");
        throw "Unauthorized";
      } else if (response.statusCode == 500) {
        debugPrint("Server Error");
        throw "Server Error";
      } else {
        debugPrint("Something does went wrong");
        throw "Something does went wrong";
      }
    } on SocketException catch (e) {
      logger.e(e);
      debugPrint("Not Internet Connection");
      throw "Not Internet Connection";
    } on FormatException catch (e) {
      logger.e(e);
      debugPrint("Bad response format");
      throw "Bad response format";
    } on DioError catch (e) {
      String? message = "";
      if (e.response?.statusCode == 400) {
        var data = json.decode(e.response.toString());
        message = data["message"] as String;
      } else if (e.response?.statusCode == 401) {
        var data = json.decode(e.response.toString());
        message = data["message"]?? "NO data" ;
      } else if (e.response?.statusCode == 500) {
        var data = json.decode(e.response.toString());
        message = data["message"] as String;
      } else {
        switch (e.type) {
          case DioErrorType.cancel:
            message = "Request to API server was cancelled";
            break;
          case DioErrorType.connectTimeout:
            message = "Connection timeout with API server";
            break;
          case DioErrorType.other:
            message = "Connection to API server failed due to internet connection";
            break;
          case DioErrorType.receiveTimeout:
            message = "Receive timeout in connection with API server";
            break;
          case DioErrorType.sendTimeout:
            message = "Send timeout in connection with API server";
            break;
          default:
            message = "Something went wrong";
            break;
        }
      }
      debugPrint(message);
      throw message ?? "No data ";
    } catch (e) {
      logger.e(e);
      debugPrint("Something went wrong");
      throw e.toString();
    }
    return null;
  }

/* Future<dynamic> request({required String url, Method? method, dynamic params}) async {
    Response response;
    debugPrint("Api url-->$url");
    try {
      if (method == Method.POST) {
        response = await _dio.post(url, data: params);
      } else if (method == Method.DELETE) {
        response = await _dio.delete(url);
      } else if (method == Method.PATCH) {
        response = await _dio.patch(url);
      } else if (method == Method.PUT) {
        response = await _dio.put(url, data: params);
      } else if (method == Method.GET) {
        response = await _dio.get(url);
      } else {
        response = await _dio.get(url, queryParameters: params);
      }
      if (response.statusCode == 200) {
        debugPrint("response--->$response");
        return response;
      } else if (response.statusCode == 400) {
        throw Exception("Invalid credential");
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      } else {
        throw Exception("Something does went wrong");
      }
    } on SocketException catch (e) {
      logger.e(e);
      throw Exception("Not Internet Connection");
    } on FormatException catch (e) {
      logger.e(e);
      throw Exception("Bad response format");
    } on DioError catch (e) {
      String? message
      = "";
      if (e.response?.statusCode == 400) {
        var data = json.decode(e.response.toString());
        message = data["message"] as String;
      } else if (e.response?.statusCode == 401) {
        var data = json.decode(e.response.toString());
        message = data["message"] as String;
      } else if (e.response?.statusCode == 500) {
        var data = json.decode(e.response.toString());
        message = data["message"] as String;
      } else {
        switch (e.type) {
          case DioErrorType.cancel:
            message = "Request to API server was cancelled";
            break;
          case DioErrorType.connectTimeout:
            message = "Connection timeout with API server";
            break;
          case DioErrorType.other:
            message =
                "Connection to API server failed due to internet connection";
            break;
          case DioErrorType.receiveTimeout:
            message = "Receive timeout in connection with API server";
            break;
          case DioErrorType.sendTimeout:
            message = "Send timeout in connection with API server";
            break;
          default:
            message = "Something went wrong";
            break;
        }
      }
      throw Exception(message);
    } catch (e) {
      // logger.e(e);
      throw Exception("Something went wrong");
    }
  }*/
}
