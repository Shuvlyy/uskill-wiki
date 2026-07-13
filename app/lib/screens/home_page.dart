import 'package:app/layouts/main_page_layout.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MainPageLayout(
      body: Center(
        child: Text('HOME PAGE')
      )
    );
  }
}
