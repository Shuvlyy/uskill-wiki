import 'package:app/core/theme.dart';
import 'package:app/widgets/navbar.dart';
import 'package:flutter/material.dart';

class MainPageLayout extends StatelessWidget {
  final Widget body;

  MainPageLayout({required this.body, super.key});

  final navbarItems = [
    NavbarItem(
      label: 'Ressources',
      route: '/resources'
    ),
    NavbarItem(
      label: 'Dépôt de ressource',
      route: '/resource-deposit'
    ),
    NavbarItem(
      label: 'À propos',
      route: '/about'
    ),
    NavbarItem(
      label: '((WIDGET TEST))',
      route: '/widget-test'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(items: navbarItems),
      drawer: NavbarDrawer(items: navbarItems),
      body: SelectionArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ClipRect(
                child: Transform.scale(
                  scale: 6,
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'assets/images/Header-banner.jpg',
                    height: 30,
                    repeat: ImageRepeat.repeatX,
                    alignment: Alignment.topLeft,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: body,
              ),
            ),
        
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    color: AppTheme.blackColor,
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '© 2026 U-Skill Wiki',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            )
          ]
        ),
      ),
    );
  }
}
