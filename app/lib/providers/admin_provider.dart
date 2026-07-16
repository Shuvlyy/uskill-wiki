import 'package:app/api/api_repository.dart';
import 'package:app/models/resource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminCredentials {
  final String email;
  final String password;

  AdminCredentials({required this.email, required this.password});
}

class AdminCredentialsNotifier extends Notifier<AdminCredentials?> {
  @override
  AdminCredentials? build() => null;

  void setCredentials(String email, String password) {
    state = AdminCredentials(email: email, password: password);
  }
}

final adminCredentialsProvider = NotifierProvider<AdminCredentialsNotifier, AdminCredentials?>(AdminCredentialsNotifier.new);

final pendingResourcesProvider = FutureProvider<List<Resource>>((ref) async {
  final credentials = ref.watch(adminCredentialsProvider);
  if (credentials == null || credentials.email.isEmpty || credentials.password.isEmpty) {
    return [];
  }

  final api = ref.watch(apiRepositoryProvider);
  return await api.getPendingResources(credentials.email, credentials.password);
  // try {
  //   print('trying to get pending resources');
  //   return await api.getPendingResources(credentials.email, credentials.password);
  // } catch (e) {
  //   print('CATCHED ERROR $e');
  //   rethrow;
  //   return [];
  // }
});

final adminActionProvider = Provider((ref) {
  return AdminActionNotifier(ref);
});

class AdminActionNotifier {
  final Ref ref;
  AdminActionNotifier(this.ref);

  Future<void> approveResource(String resourceId) async {
    final credentials = ref.read(adminCredentialsProvider);
    if (credentials == null) {
      return;
    }

    final api = ref.read(apiRepositoryProvider);
    await api.updateResourceStatus(credentials.email, credentials.password, resourceId, 'approved');
    ref.invalidate(pendingResourcesProvider);
  }

  Future<void> rejectResource(String resourceId) async {
    final credentials = ref.read(adminCredentialsProvider);
    if (credentials == null) {
      return;
    }

    final api = ref.read(apiRepositoryProvider);
    await api.updateResourceStatus(credentials.email, credentials.password, resourceId, 'rejected');
    ref.invalidate(pendingResourcesProvider);
  }
}
