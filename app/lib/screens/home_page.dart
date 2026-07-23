import 'package:app/core/utils.dart';
import 'package:app/layouts/main_page_layout.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/theme.dart';
import 'package:app/widgets/button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return MainPageLayout(
      defaultPadding: false,
      body: Column(
        children: [
          // banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final textPart = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: .center,
                      children: [
                        Text(
                          context.l10n.homePageBannerTitle,
                          style: textTheme.displayMedium?.copyWith(
                            fontWeight: .bold,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          context.l10n.homePageBannerSubtitle,
                          style: textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                            height: 1.6,
                            color: AppTheme.inactiveTextColor,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            Button.primary(
                              text: context.l10n.exploreWiki,
                              onPressed: () {
                                context.go('/resources');
                              },
                            ),
                            Button.secondary(
                              text: 'U-Skill',
                              onPressed: () {
                                launchUrl(Uri.parse('https://u-skill.univ-nantes.fr'));
                              },
                            ),
                          ],
                        ),
                      ],
                    );

                    final imagePart = Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: AppTheme.avatarBgColor,
                        border: Border.all(color: AppTheme.fieldOutlineColor),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/main.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );

                    if (constraints.maxWidth > 800) {
                      return Row(
                        crossAxisAlignment: .center,
                        spacing: 60,
                        children: [
                          Expanded(flex: 5, child: textPart),
                          Expanded(flex: 7, child: imagePart),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 40,
                        children: [
                          textPart,
                          imagePart,
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),

          // Content sections
          Container(
            width: double.infinity,
            color: AppTheme.whiteColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  spacing: 60,
                  children: [
                    _buildSection(
                      textTheme,
                      title: context.l10n.twoDevicesOneEntry,
                      subtitle: context.l10n.univbuddyAndEtandem,
                      content: context.l10n.twoDevicesContent,
                      imagePath: 'assets/images/univbuddy_etandem.jpg',
                      imageLeft: true,
                    ),

                    _buildSection(
                      textTheme,
                      title: context.l10n.uSkillWiki,
                      subtitle: context.l10n.constellationOfResources,
                      content: context.l10n.wikiContent,
                      imagePath: 'assets/images/constellation_view.png',
                      imageLeft: false,
                    ),

                    _buildSection(
                      textTheme,
                      title: context.l10n.designedBySul,
                      subtitle: context.l10n.teamBehindWiki,
                      content: context.l10n.teamContent,
                      extraContent: _buildTeamEmails(textTheme, context),
                      imagePath: 'assets/images/team.jpg',
                      imageLeft: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamEmails(TextTheme textTheme, BuildContext context) {
    final mainTeam = [
      { 'name': 'Barbara Chicotot', 'email': 'barbara.chicotot@univ-nantes.fr' },
      { 'name': 'Dolly Ramella', 'email': 'dolly.ramella@univ-nantes.fr' },
      { 'name': 'Leslie de Bond', 'email': 'leslie.debond@univ-nantes.fr' },
      { 'name': 'Isabelle Richard', 'email': 'isabelle.richard@univ-nantes.fr' },
    ];

    final devTeam = [
      { 'name': 'Lysandre Boursette', 'email': 'lysandre.boursette@epitech.eu' },
    ];

    Widget buildCategory(String title, List<Map<String, String>> team) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.blackColor,
              ),
            ),
          ),
          ...team.map((member) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => launchUrl(Uri.parse('mailto:${member['email']}')),
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodyLarge?.copyWith(fontSize: 18),
                    children: [
                      TextSpan(
                        text: '• ${member['name']} - ',
                        style: const TextStyle(color: AppTheme.blackColor)
                      ),
                      TextSpan(
                        text: member['email'],
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          decoration: TextDecoration.underline
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCategory(context.l10n.mainTeam, mainTeam),
        buildCategory(context.l10n.devTeam, devTeam),
      ],
    );
  }

  Widget _buildSection(
    TextTheme textTheme,
    {
      required String title,
      required String subtitle,
      required String content,
      Widget? extraContent,
      required String imagePath,
      required bool imageLeft
    }
  ) {
    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          title.toUpperCase(),
          style: textTheme.labelLarge?.copyWith(
            color: AppTheme.primaryColor,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.blackColor,
          ),
        ),
        const Gap(5),
        Text(
          content,
          style: textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: AppTheme.inactiveTextColor,
            fontSize: 18,
          ),
        ),
        if (extraContent != null) ...[
          extraContent,
        ],
      ],
    );

    final imageContent = Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: AppTheme.avatarBgColor,
        border: Border.all(color: AppTheme.fieldOutlineColor),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Row(
            crossAxisAlignment: .center,
            spacing: 50,
            children: [
              if (imageLeft) Expanded(flex: 5, child: imageContent),
              Expanded(flex: 7, child: textContent),
              if (!imageLeft) Expanded(flex: 5, child: imageContent)
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 30,
            children: [
              imageContent,
              textContent,
            ],
          );
        }
      },
    );
  }
}
