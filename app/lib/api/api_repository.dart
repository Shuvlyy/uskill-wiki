import 'package:app/core/constants.dart';
import 'package:app/models/resource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: Constants.apiUrl,
    connectTimeout: const Duration(seconds: 10),
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

    print('before getting the thing lol');

    final response = await _dio.get(
      '/resources/',
      queryParameters: queryParams,
      options: Options(listFormat: ListFormat.multi),
    );

    print(response);
    print(response.data as List);

    return (response.data as List).map((e) => Resource.fromJson(e)).toList();
  }

  Future<Resource> submitResource(Resource resource) async {
    final response = await _dio.post(
      '/resources/',
      data: resource.toJson(),
    );
    return Resource.fromJson(response.data);
  }
}