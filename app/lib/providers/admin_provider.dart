import 'package:app/api/api_repository.dart';
import 'package:app/models/resource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminTokenNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setToken(String token) {
    state = token;
  }
}

final adminTokenProvider = NotifierProvider<AdminTokenNotifier, String?>(AdminTokenNotifier.new);

final pendingResourcesProvider = FutureProvider<List<Resource>>((ref) async {
  final token = ref.watch(adminTokenProvider);
  if (token == null || token.isEmpty) {
    return [];
  }

  final api = ref.watch(apiRepositoryProvider);
  return api.getPendingResources(token);
});

final adminActionProvider = Provider((ref) {
  return AdminActionNotifier(ref);
});

class AdminActionNotifier {
  final Ref ref;
  AdminActionNotifier(this.ref);

  Future<void> approveResource(String resourceId) async {
    final token = ref.read(adminTokenProvider);
    if (token == null) {
      return;
    }

    final api = ref.read(apiRepositoryProvider);
    await api.updateResourceStatus(token, resourceId, 'approved');
    ref.invalidate(pendingResourcesProvider);
  }

  Future<void> rejectResource(String resourceId) async {
    final token = ref.read(adminTokenProvider);
    if (token == null) {
      return;
    }

    final api = ref.read(apiRepositoryProvider);
    await api.updateResourceStatus(token, resourceId, 'rejected');
    ref.invalidate(pendingResourcesProvider);
  }
}
