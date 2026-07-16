import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/api/api_repository.dart';
import 'package:app/models/resource.dart';

final resourcesProvider = FutureProvider.autoDispose<List<Resource>>((ref) async {
  final repository = ref.watch(apiRepositoryProvider);
  return repository.getResources();
});
