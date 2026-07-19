import 'package:app/screens/about_page.dart';
import 'package:app/screens/constellation_view.dart';
import 'package:app/screens/home_page.dart';
import 'package:app/screens/resource_deposit/resource_deposit_page.dart';
import 'package:app/screens/resource_search/resources_page.dart';
import 'package:app/screens/admin_panel_page.dart';
import 'package:app/screens/widget_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const NoTransitionPage(child: HomePage()),
      ),
      GoRoute(
        path: '/constellation',
        pageBuilder: (context, state) => const NoTransitionPage(child: ConstellationViewPage())
      ),
      GoRoute(
        path: '/resources',
        pageBuilder: (context, state) => const NoTransitionPage(child: ResourcesPage()),
      ),
      GoRoute(
        path: '/resource-deposit',
        pageBuilder: (context, state) => const NoTransitionPage(child: ResourceDepositPage()),
      ),
      GoRoute(
        path: '/about',
        pageBuilder: (context, state) => const NoTransitionPage(child: AboutPage()),
      ),
      GoRoute(
        path: '/widget-test',
        pageBuilder: (context, state) => const NoTransitionPage(child: WidgetTest()),
      ),
      GoRoute(
        path: '/admin',
        pageBuilder: (context, state) => const NoTransitionPage(child: AdminPanelPage()),
      ),
    ],
  );
});
