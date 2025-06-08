import 'dart:async';
import 'package:Tosell/core/Client/ApiResponse.dart';
import 'package:Tosell/core/helpers/SharedPreferencesHelper.dart';
import 'package:dio/dio.dart';

// const imageUrl = "http://192.168.1.55:5051/";
const imageUrl = "https://toseel-api.future-wave.co/";
const baseUrl = "$imageUrl" "api";

class BaseClient<T> {
  final T Function(Map<String, dynamic>)? fromJson;
  final Dio _dio = Dio();
  final int _timeoutSeconds = 30;

  BaseClient({this.fromJson}) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: _timeoutSeconds),
      receiveTimeout: Duration(seconds: _timeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = (await SharedPreferencesHelper.getUser())?.token;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await SharedPreferencesHelper.removeUser();
        }
        return handler.next(error);
      },
    ));
  }

  Future<ApiResponse<T>> create({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> getById({
    required String endpoint,
    required String id,
  }) async {
    try {
      final response = await _dio.get('$endpoint/$id');
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> get({required String endpoint}) async {
    try {
      final response = await _dio.get(endpoint);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  FutureOr<T> get_noResponse({required String endpoint}) async {
    try {
      final response = await _dio.get(endpoint);
      return fromJson!(response.data);
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future<ApiResponse<T>> getAll(
      {required String endpoint,
      int page = 1,
      Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: {
          ...?queryParams,
          'pageNumber': page,
        },
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> update({
    required String endpoint,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<ApiResponse<T>> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<ApiResponse<String>> uploadFile(String selectedImagePath) async {
    try {
      final formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(
          selectedImagePath,
          filename: selectedImagePath.split('/').last,
        ),
      });

      final response = await _dio.post(
        '/file/multi',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        final urls = (response.data['data'] as List)
            .map<String>((file) => file['url'].toString())
            .toList();
        return ApiResponse<String>(data: urls);
      }
      return ApiResponse<String>(
        message: response.data['message'] ?? 'Upload failed',
        data: [],
        errorType: ApiErrorType.serverError,
      );
    } on DioException catch (e) {
      return ApiResponse<String>(
        message: e.response?.data['message'] ?? 'Upload error',
        data: [],
        errorType: ApiErrorType.serverError,
      );
    }
  }

  ApiResponse<T> _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return ApiResponse.fromJsonAuto(response.data, fromJson!);
    }
    return ApiResponse<T>(
      message: response.data['message'] ?? 'Unknown error',
      data: [],
      errors: response.data['errors'],
      errorType: ApiErrorType.serverError,
    );
  }

  ApiResponse<T> _handleDioError(DioException e) {
    ApiErrorType errorType;
    String message = '';

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorType = ApiErrorType.timeout;
        message = 'Request timed out';
        break;
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          errorType = ApiErrorType.unauthorized;
          message = 'Unauthorized';
        } else {
          errorType = ApiErrorType.serverError;
          message = e.response?.data['message'] ?? 'Server error';
        }
        break;
      case DioExceptionType.cancel:
        errorType = ApiErrorType.unknown;
        message = 'Request cancelled';
        break;
      case DioExceptionType.unknown:
        if (e.message != null && e.message!.contains('SocketException')) {
          errorType = ApiErrorType.noInternet;
          message = 'No internet connection';
        } else {
          errorType = ApiErrorType.unknown;
          message = 'Unknown error: ${e.message}';
        }
        break;
      default:
        errorType = ApiErrorType.unknown;
        message = 'Unexpected error';
    }

    return ApiResponse<T>(
      message: message,
      data: [],
      errors: e.response?.data['errors'],
      errorType: errorType,
    );
  }
}
