import 'package:app/core/theme.dart';
import 'package:app/models/resource.dart';
import 'package:app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:app/core/utils.dart';

class ResourceCard extends StatelessWidget {
  final Resource resource;

  const ResourceCard({required this.resource, super.key});

  String _getLanguageLabel(String code) {
    switch (code.toLowerCase()) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'Anglais';
      case 'es':
        return 'Espagnol';
      default:
        return code;
    }
  }

  String _getResourceTypeLabel(ResourceType type) {
    switch (type) {
      case ResourceType.exercise:
        return 'Exercice';
      case ResourceType.activity:
        return 'Activité';
      case ResourceType.game:
        return 'Jeu';
      case ResourceType.video:
        return 'Vidéo';
      case ResourceType.audio:
        return 'Audio';
      case ResourceType.article:
        return 'Article';
      case ResourceType.pdf:
        return 'PDF';
      case ResourceType.text:
        return 'Texte';
      case ResourceType.image:
        return 'Image';
    }
  }

  IconData _getResourceTypeIcon(ResourceType type) {
    switch (type) {
      case ResourceType.exercise:
        return Icons.edit_note;
      case ResourceType.activity:
        return Icons.local_activity_outlined;
      case ResourceType.game:
        return Icons.videogame_asset_outlined;
      case ResourceType.video:
        return Icons.play_circle_outline;
      case ResourceType.audio:
        return Icons.audiotrack_outlined;
      case ResourceType.article:
        return Icons.description_outlined;
      case ResourceType.pdf:
        return Icons.picture_as_pdf_outlined;
      case ResourceType.text:
        return Icons.text_snippet_outlined;
      case ResourceType.image:
        return Icons.image_outlined;
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Icons.school_outlined;
      case UserRole.teacher:
        return Icons.person_outline;
      case UserRole.staff:
        return Icons.badge_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBgColor,
        border: Border.all(color: AppTheme.cardBorderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resource.title,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            const Gap(15),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (resource.targetAudiences.isNotEmpty)
                  _buildInfoBadge(
                    _getRoleIcon(resource.targetAudiences.first),
                    resource.targetAudiences
                      .map((e) => e.name[0].toUpperCase() + e.name.substring(1))
                      .join(', '),
                  ),
                _buildInfoBadge(_getResourceTypeIcon(resource.type), _getResourceTypeLabel(resource.type)),
                _buildInfoBadge(Icons.language, _getLanguageLabel(resource.language)),
                _buildLevelBadge(resource.level),
              ],
            ),
            if (resource.description.isNotEmpty) ... {
              const Gap(15),
              Text(
                resource.description,
                style: Theme.of(context).textTheme.bodyMedium!,
                maxLines: 4,
              ),
            },
            const Gap(20),
            const Divider(color: AppTheme.cardBorderColor, height: 1),
            const Gap(20),
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isNarrow = constraints.maxWidth < 500;

                final authorInfo = Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.avatarBgColor,
                        border: Border.all(color: AppTheme.cardBorderColor),
                      ),
                      child: const Icon(Icons.person_outline, color: AppTheme.iconColor),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            resource.author.name,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            resource.author.email,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.inactiveTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );

                final button = Button.primary(
                  text: "Consulter la ressource",
                  onPressed: () {
                    Utils.launch(resource.contentUrl);
                  },
                  icon: Icons.arrow_forward,
                  verticalPadding: 20,
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      authorInfo,
                      const Gap(20),
                      button,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: authorInfo),
                    const Gap(12),
                    button,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.cardBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Icon(icon, size: 16, color: AppTheme.iconColor),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.iconColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelBadge(LanguageLevel level) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
      ),
      child: Text(
        level.name.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
