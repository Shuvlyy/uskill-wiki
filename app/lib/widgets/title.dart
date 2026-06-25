import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  const Title({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        Container(width: 50, height: 5, color: Theme.of(context).primaryColor),
      ],
    );
  }
}
