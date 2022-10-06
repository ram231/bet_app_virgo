import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const defaultUrl = 'http://10.0.2.2:8000';
const api = const String.fromEnvironment('API',
    defaultValue: 'https://api.smalltownlottery.online');
final _url = '$api';
const adminEndpoint = 'api/lotto';
typedef string = String;

class STLHttpClient {
  STLHttpClient({Options? options})
      : _options = options ??
            Options(
              followRedirects: false,
              headers: {"Accept": "application/json"},
            );
  final Options _options;
  final _httpClient = Dio();

  Future<Response> get<Response>(
    String path, {
    Map<string, dynamic> queryParams = const {},
    dynamic Function(Object error)? onError,
    Response Function(Map<String, dynamic> json)? onSerialize,
  }) async {
    final response = await _httpClient.get(
      "$_url/$path",
      queryParameters: {
        ...queryParams,
        "rows_per_page": 1000000,
      },
      options: _options,
    );
    final rawUri = Uri.decodeFull("${response.realUri}");
    debugPrint("GET::${rawUri}");
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
    final response = await _httpClient.post(
      "$_url/$path",
      data: body,
      queryParameters: queryParams,
      options: _options,
    );
    final rawUri = Uri.decodeFull("${response.realUri}");
    debugPrint("POST::${rawUri}");
    final statusCode = response.statusCode ?? 400;
    if (statusCode >= 400) {
      throw HttpException(onError?.call(response.data) ??
          response.data['message'] ??
          response.data);
    }

    return onSerialize?.call(response.data) ?? response.data as Response;
  }

  Future<Response> delete<Response>(
    String path, {
    Map<string, dynamic>? queryParams,
    Map<String, dynamic>? body,
    dynamic Function(Object error)? onError,
    Response Function(Map<String, dynamic> json)? onSerialize,
  }) async {
    final response = await _httpClient.delete(
      "$_url/$path",
      data: body,
      queryParameters: queryParams,
      options: _options,
    );

    final rawUri = Uri.decodeFull("${response.realUri}");
    debugPrint("DELETE::${rawUri}");
    final statusCode = response.statusCode ?? 400;
    if (statusCode >= 400) {
      throw HttpException(onError?.call(response.data) ??
          response.data['message'] ??
          response.data);
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
    final rawUri = Uri.decodeFull("${response.realUri}");
    debugPrint("PUT::${rawUri}");
    final statusCode = response.statusCode ?? 400;
    if (statusCode >= 400) {
      throw onError?.call(response.data) ??
          response.data['error'] ??
          response.data;
    }

    return response.data as Response;
  }
}

String throwableDioError(Object error) {
  if (error is SocketException) {
    return error.message;
  }
  if (error is DioError) {
    final responseMessage = error.response?.data;
    if (responseMessage is Map) {
      final errors = (responseMessage['errors'] as Map).values.map((e) {
        final messages = e;
        return messages.join("\n");
      }).join("");
      return "$errors";
    }
    final statusMessage = error.response?.statusMessage ?? error.message;
    return statusMessage;
  }
  return "$error";
}
