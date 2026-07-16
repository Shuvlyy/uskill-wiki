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
                  'Admin Panel',
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
          label: 'Admin Email',
          controller: _emailController,
          hintText: 'Enter your admin email',
          obscureText: false,
        ),
        const Gap(20),
        LabeledTextFormField(
          label: 'Admin Password',
          controller: _passwordController,
          hintText: 'Enter your admin password',
          obscureText: true,
        ),
        const Gap(20),
        Button.primary(
          text: 'Login',
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
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Text('No pending resources found.'),
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
            'Erreur',
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
            text: 'Retour à la connexion',
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
