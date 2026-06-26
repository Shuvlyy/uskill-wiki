import 'package:flutter/material.dart';

enum TitleDecorationAlignment { normal, center }

class Title extends StatelessWidget {
  const Title({
    super.key,
    required this.title,
    this.decorationAlignment = .normal,
  });

  final String title;
  final TitleDecorationAlignment decorationAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: decorationAlignment == .center ? .center : .start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        Container(width: 50, height: 5, color: Theme.of(context).primaryColor),
      ],
    );
  }
}
