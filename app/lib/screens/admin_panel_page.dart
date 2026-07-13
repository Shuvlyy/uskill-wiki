import 'package:app/core/theme.dart';
import 'package:app/layouts/main_page_layout.dart';
import 'package:app/providers/admin_provider.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/labeled_text_form_field.dart';
import 'package:app/widgets/resource_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AdminPanelPage extends ConsumerStatefulWidget {
  const AdminPanelPage({super.key});

  @override
  ConsumerState<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends ConsumerState<AdminPanelPage> {
  final _tokenController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final token = ref.watch(adminTokenProvider);

    return MainPageLayout(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Panel',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(20),
                if (token == null || token.isEmpty)
                  _buildTokenForm()
                else
                  _buildPendingResources(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTokenForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledTextFormField(
          label: 'Admin Token',
          controller: _tokenController,
          hintText: 'Enter your admin token',
          obscureText: true,
        ),
        const Gap(20),
        Button.primary(
          text: 'Login',
          onPressed: () {
            ref.read(adminTokenProvider.notifier).setToken(_tokenController.text);
          },
        ),
      ],
    );
  }

  Widget _buildPendingResources() {
    final pendingResources = ref.watch(pendingResourcesProvider);

    return pendingResources.when(
      data: (resources) {
        if (resources.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Text('No pending resources found.'),
            ),
          );
        }

        return Column(
          children: resources.map((resource) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.cardBorderColor),
                ),
                child: Column(
                  children: [
                    ResourceCard(resource: resource),
                    Container(
                      padding: const EdgeInsets.all(15),
                      color: AppTheme.cardBgColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 15,
                        children: [
                          Button.secondary(
                            text: 'Reject',
                            onPressed: () {
                              ref.read(adminActionProvider).rejectResource(resource.id!);
                            },
                          ),
                          Button.primary(
                            text: 'Approve',
                            onPressed: () {
                              ref.read(adminActionProvider).approveResource(resource.id!);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}
