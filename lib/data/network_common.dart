import 'dart:convert';
import 'package:burgan_task/data/network_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NetworkCommon {
  static final NetworkCommon _singleton = NetworkCommon._internal();
  static String baseUrl = dotenv.get('BASE_URL');

  factory NetworkCommon() {
    return _singleton;
  }

  NetworkCommon._internal();

  final JsonDecoder _decoder = const JsonDecoder();

  dynamic decodeResp(d) {
    if (d is Response) {
      final dynamic jsonBody = d.data;
      final statusCode = d.statusCode;

      if (statusCode! < 200 || statusCode >= 300 || jsonBody == null) {
        throw Exception("statusCode: $statusCode");
      }

      if (jsonBody is String && jsonBody.isNotEmpty) {
        return _decoder.convert(jsonBody);
      } else {
        return jsonBody;
      }
    } else {
      throw d;
    }
  }

  Dio get dio {
    Dio dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(milliseconds: 50000);
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    dio.interceptors.addAll({
      AuthInterceptor(dio),
      ErrorInterceptors(dio),
      Logging(dio),
    });

    return dio;
  }
}
