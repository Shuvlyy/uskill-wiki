import 'package:app/core/utils.dart';
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final credentials = ref.watch(adminCredentialsProvider);

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
                  context.l10n.adminPanel,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(20),
                if (credentials == null || credentials.email.isEmpty || credentials.password.isEmpty)
                  _buildCredentialsForm()
                else
                  _buildPendingResources(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCredentialsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledTextFormField(
          label: context.l10n.adminEmail,
          controller: _emailController,
          hintText: context.l10n.enterAdminEmail,
          obscureText: false,
        ),
        const Gap(20),
        LabeledTextFormField(
          label: context.l10n.adminPassword,
          controller: _passwordController,
          hintText: context.l10n.enterAdminPassword,
          obscureText: true,
        ),
        const Gap(20),
        Button.primary(
          text: context.l10n.login,
          onPressed: () {
            ref.read(adminCredentialsProvider.notifier).setCredentials(
              _emailController.text,
              _passwordController.text,
            );
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
          return Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Text(context.l10n.noPendingResources),
            ),
          );
        }

        if (resources.first == null) {
          return _buildError(Exception('Invalid credentials'));
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
                    ResourceCard(resource: resource!),
                    Container(
                      padding: const EdgeInsets.all(15),
                      color: AppTheme.cardBgColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 15,
                        children: [
                          Button.secondary(
                            text: context.l10n.reject,
                            onPressed: () {
                              ref.read(adminActionProvider).rejectResource(resource.id!);
                            },
                          ),
                          Button.primary(
                            text: context.l10n.approve,
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
      error: (err, _) => _buildError(err),
    );
  }

  Widget _buildError(Object err) {
    return Container(
      padding: const EdgeInsets.all(40),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            color: Colors.red,
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 40,
            ),
          ),
          const Gap(40),
          Text(
            context.l10n.error,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          Text(
            err.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.inactiveTextColor,
            ),
          ),
          const Gap(40),
          Button.secondary(
            text: context.l10n.backToLogin,
            onPressed: () {
              ref.read(adminCredentialsProvider.notifier).setCredentials('', '');
            },
            icon: Icons.arrow_back,
            verticalPadding: 20,
          ),
        ],
      ),
    );
  }
}
