import 'package:dio/dio.dart';

const api = const String.fromEnvironment('API', defaultValue: '');
final _url = 'http://$api';
const adminEndpoint = 'api/lotto';
typedef string = String;

class STLHttpClient {
  final _httpClient = Dio();

  Future<Response> get<Response>(
    String path, {
    Map<string, dynamic>? queryParams,
    dynamic Function(Object error)? onError,
    Response Function(Map<String, dynamic> json)? onSerialize,
  }) async {
    final response =
        await _httpClient.get("$_url/$path", queryParameters: queryParams);
    final statusCode = response.statusCode ?? 400;
    if (statusCode >= 400) {
      throw onError?.call(response.data) ??
          response.data['error'] ??
          response.data;
    }

    return onSerialize?.call(response.data) ?? response.data as Response;
  }

  Future<Response> post<Response>(
    String path, {
    Map<string, dynamic>? queryParams,
    Map<String, dynamic>? body,
    dynamic Function(Object error)? onError,
    Response Function(Map<String, dynamic> json)? onSerialize,
  }) async {
    final response = await _httpClient.post("$_url/$path",
        data: body,
        queryParameters: queryParams,
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status != null && status < 500,
            headers: {"Accept": "application/json"}));
    final statusCode = response.statusCode ?? 400;
    if (statusCode >= 400) {
      throw onError?.call(response.data) ??
          response.data['error'] ??
          response.data;
    }

    return onSerialize?.call(response.data) ?? response.data as Response;
  }

  Future<Response> put<Response>(
    String path, {
    Map<string, dynamic>? queryParams,
    Map<String, dynamic>? body,
    dynamic Function(Object error)? onError,
  }) async {
    final response = await _httpClient.put("$_url/$path",
        data: body, queryParameters: queryParams);
    final statusCode = response.statusCode ?? 400;
    if (statusCode >= 400) {
      throw onError?.call(response.data) ??
          response.data['error'] ??
          response.data;
    }

    return response.data as Response;
  }
}
