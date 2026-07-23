import 'package:app/core/utils.dart';
import 'package:app/layouts/main_page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/resources_provider.dart';
import 'package:app/widgets/constellation_view.dart';

class ConstellationViewPage extends ConsumerStatefulWidget {
  const ConstellationViewPage({super.key});

  @override
  ConsumerState<ConstellationViewPage> createState() => _ConstellationViewPageState();
}

class _ConstellationViewPageState extends ConsumerState<ConstellationViewPage> {
  @override
  Widget build(BuildContext context) {
    final resourcesAsync = ref.watch(resourcesProvider);

    return MainPageLayout(
      defaultPadding: false,
      fillRemaining: true,
      body: resourcesAsync.when(
        data: (resources) => ConstellationView(resources: resources),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('${context.l10n.error}: $error')),
      ),
    );
  }
}
