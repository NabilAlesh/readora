import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constant/urls.dart';
import '../utils/helper/cach_helper.dart';
import '../utils/helper/cach_helper_keys.dart';

class Network {
  static late Dio dio;

  static Future<void> init() async {
    await CacheHelper.init();

    String? token = CacheHelper.getData(key: CacheHelperKeys.token);

    dio = Dio(
      BaseOptions(
        baseUrl: Urls.baseUrl,
        connectTimeout: const Duration(seconds: 50),
        receiveTimeout: const Duration(seconds: 50),
        headers: {
          'Authorization': "Bearer ${token ?? ''}",
          'Content-Type': 'application/json',
          "Accept": 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        request: true,
        compact: true,
        maxWidth: 1000,
      ),
    );

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
  }

  // ------------------- GET -------------------
  static Future<Response> getData({
    required String url,
    bool requiresAuth = false,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Accept": 'application/json',
    };

    if (requiresAuth) {
      final token = CacheHelper.getData(key: CacheHelperKeys.token);
      if (token != null) {
        headers['Authorization'] = "Bearer $token";
      }
    }

    dio.options.headers = headers;
    final response = await dio.get(url);
    return response;
  }

  // ------------------- POST  -------------------
  static Future<Response> postData({
    required String url,
    dynamic data,
    bool requiresAuth = true,
  }) async {
    bool isMultipart = data is FormData;

    Map<String, String> headers = {"Accept": 'application/json'};

    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }

    if (requiresAuth) {
      final token = CacheHelper.getData(key: CacheHelperKeys.token);
      if (token != null) {
        headers['Authorization'] = "Bearer $token";
      }
    }

    dio.options.headers = headers;
    return await dio.post(url, data: data);
  }

  // ------------------- PUT -------------------
  static Future<Response> putData({required String url, dynamic data}) async {
    Map<String, String> headers = {"Accept": 'application/json'};
    final token = CacheHelper.getData(key: CacheHelperKeys.token);
    if (token != null) {
      headers['Authorization'] = "Bearer $token";
    }
    dio.options.headers = headers;
    return await dio.put(url, data: data);
  }

  // ------------------- PATCH -------------------
  static Future<Response> patchData({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    Map<String, String> headers = {"Accept": 'application/json'};
    final token = CacheHelper.getData(key: CacheHelperKeys.token);
    if (token != null) {
      headers['Authorization'] = "Bearer $token";
    }
    dio.options.headers = headers;
    return await dio.patch(url, data: data);
  }

  // ------------------- DELETE -------------------
  static Future<Response> deleteData({
    required String url,
    dynamic data,
  }) async {
    Map<String, String> headers = {"Accept": 'application/json'};
    final token = CacheHelper.getData(key: CacheHelperKeys.token);
    if (token != null) {
      headers['Authorization'] = "Bearer $token";
    }
    dio.options.headers = headers;
    return await dio.delete(url, data: data);
  }
}
