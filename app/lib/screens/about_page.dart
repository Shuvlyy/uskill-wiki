import 'package:app/layouts/main_page_layout.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainPageLayout(
      body: Center(
        child: Text('ABOUT'),
      )
    );
  }
}
