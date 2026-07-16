import 'package:app/core/constants.dart';
import 'package:app/models/resource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: Constants.apiUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
});

final apiRepositoryProvider = Provider<ApiRepository>((ref) {
  return ApiRepository(ref.watch(dioProvider));
});

class ApiRepository {
  final Dio _dio;

  ApiRepository(this._dio);

  Future<List<Resource>> getResources({
    UserRole? role,
    String? language,
    LearningFocus? focus,
    List<String>? tags,
  }) async {
    final queryParams = <String, dynamic>{};
    if (role != null) queryParams['role'] = role.name;
    if (language != null) queryParams['language'] = language;
    if (focus != null) queryParams['focus'] = focus.name;
    if (tags != null && tags.isNotEmpty) queryParams['tags'] = tags;

    try {
      final response = await _dio.get(
        '/resources/',
        queryParameters: queryParams,
        options: Options(listFormat: ListFormat.multi),
      );

      return (response.data as List).map((e) => Resource.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Resource> submitResource(Resource resource) async {
    try {
      final response = await _dio.post(
        '/resources/',
        data: resource.toJson(),
      );
      return Resource.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<Resource>> getPendingResources(String adminEmail, String adminPassword) async {
    try {
      final response = await _dio.get(
        '/resources/pending',
        options: Options(
          headers: {
            'x-admin-email': adminEmail,
            'x-admin-password': adminPassword,
          },
        ),
      );

      return (response.data as List).map((e) => Resource.fromJson(e)).toList();
    } catch (e) {
      print('catched exception $e');
      if (e is DioException) {
        print('its dioexception lol');
        final ex = _handleDioError(e);;
        print('will throw $ex');
        throw ex;
      }
      rethrow;
    }
  }

  Future<Resource> updateResourceStatus(
    String adminEmail,
    String adminPassword,
    String resourceId,
    String status
  ) async {
    try {
      final response = await _dio.patch(
        '/resources/$resourceId/status',
        queryParameters: { 'status': status },
        options: Options(headers: {
          'x-admin-email': adminEmail,
          'x-admin-password': adminPassword,
        }),
      );
      return Resource.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      if (statusCode == 403) {
        print('403!!!');
        return Exception('Invalid credentials.');
      }

      if (statusCode == 422 && data is Map && data.containsKey('detail')) {
        final details = data['detail'] as List;
        if (details.isNotEmpty) {
          final field = details[0]['loc'].last;
          final msg = details[0]['msg'];
          return Exception('Validation failed for "$field": $msg');
        }
        return Exception('Invalid data submitted.');
      }

      return Exception('Server Error ($statusCode). Please try again later.');
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Connection timed out. Please check your internet.');
        case DioExceptionType.connectionError:
          return Exception('Could not connect to the API. Is the server running?');
        default:
          return Exception('Network error: ${e.message}');
      }
    }
  }
}
