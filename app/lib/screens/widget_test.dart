import 'package:app/widgets/button.dart';
import 'package:app/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;

class WidgetTest extends StatefulWidget {
  const WidgetTest({super.key});

  @override
  State<WidgetTest> createState() => _WidgetTestState();
}

class _WidgetTestState extends State<WidgetTest> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 20,
            children: [
              Title(title: 'title test'),
              Button.primary(text: 'Primary', onPressed: () {}),
              Button.secondary(text: 'Secondary', onPressed: () {}),
              Button.inverted(text: 'Inverted', onPressed: () {}),
              Button.outlined(text: 'Outlined', onPressed: () {}),
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Text form field'),
              ),
              DropdownMenu(
                hintText: 'Dropdown form field',

                expandedInsets: EdgeInsets.zero,
                requestFocusOnTap: false,

                dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                  DropdownMenuEntry<String>(value: 'item1', label: 'Item 1'),
                  DropdownMenuEntry<String>(value: 'item2', label: 'Item 2'),
                  DropdownMenuEntry<String>(value: 'item3', label: 'Item 3'),
                ],
                onSelected: (value) {
                  // Handle your selection here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
