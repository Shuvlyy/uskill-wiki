import 'package:app/core/theme.dart';
import 'package:app/models/resource.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ResourceCard extends StatelessWidget {
  final Resource resource;

  const ResourceCard({required this.resource, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.primaryColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTypeBadge(),
                const Spacer(),
                Text(
                  resource.language.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const Gap(8),
            Text(
              resource.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: AppTheme.titleFont,
              ),
            ),
            const Gap(4),
            Text(
              resource.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Gap(12),
            Wrap(
              spacing: 8,
              children: resource.tags.map((tag) => _buildTag(tag)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
      ),
      child: Text(
        resource.type.name.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '#$tag',
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      ),
    );
  }
}
