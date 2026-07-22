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
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .center,
                      children: [
                        Text(
                          'Un point commun entre campus,\nquelque part sur la carte.',
                          style: textTheme.displayMedium?.copyWith(
                            fontWeight: .bold,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'U-SkiLL relie les étudiant·es de Nantes Université à des partenaires linguistiques en France et à l\'étranger, en présentiel ou à distance — et rassemble dans un wiki les ressources pédagogiques créées pour les accompagner',
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
                              text: 'EXPLORER LE WIKI',
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
                        crossAxisAlignment: .start,
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
                      title: 'Deux dispositifs, un seul point d\'entrée',
                      subtitle: 'UnivBuddy et E-tandem',
                      content: 'Portés par le SUL, ces deux programmes de tandem visent à développer les compétences linguistiques et interculturelles, faciliter l\'accueil des étudiant·es internationaux et préparer à la mobilité internationale.',
                      imagePath: 'assets/images/univbuddy_etandem.jpg',
                      imageLeft: true,
                    ),

                    _buildSection(
                      textTheme,
                      title: 'Le wiki U-Skill',
                      subtitle: 'Une constellation de ressources',
                      content: 'Chaque ressource pédagogique du wiki se rattache à un rôle, une thématique et un niveau — à l\'image d\'une carte du ciel où chaque étoile trouve sa place dans une branche : langue, vie universitaire ou objectifs linguistiques.',
                      imagePath: 'assets/images/constellation_view.png',
                      imageLeft: false,
                    ),

                    _buildSection(
                      textTheme,
                      title: 'Conçu par le SUL',
                      subtitle: 'L\'équipe derrière le wiki',
                      content: 'U-Skill et son wiki de ressources REL sont pensés et alimentés par l\'équipe du Service Universitaire des Langues de Nantes Université.',
                      extraContent: _buildTeamEmails(textTheme),
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

  Widget _buildTeamEmails(TextTheme textTheme) {
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
      crossAxisAlignment: .start,
      children: [
        buildCategory('Équipe principale', mainTeam),
        buildCategory('Développement du wiki & photos', devTeam),
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
            crossAxisAlignment: .start,
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
