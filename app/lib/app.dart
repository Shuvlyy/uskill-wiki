import 'package:app/core/constants.dart';
import 'package:app/core/router.dart';
import 'package:app/core/theme.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: Constants.appName,
      debugShowCheckedModeBanner: true,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: AppTheme.light(),
      // darkTheme: AppTheme.dark(),
    );
  }
}
