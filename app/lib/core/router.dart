import 'package:app/screens/home_page.dart';
import 'package:app/screens/widget_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/widget-test',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const HomePage()),
      GoRoute(path: '/widget-test', builder: (_, _) => const WidgetTest()),
    ],
  );
});
