import 'package:app/layouts/main_page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/resources_provider.dart';
import 'package:app/widgets/constellation_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainPageLayout(
      body: Center(
        child: Text('HOME PAGE'),
      ),
    );
  }
}
