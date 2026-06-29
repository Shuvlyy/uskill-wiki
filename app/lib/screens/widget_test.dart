import 'package:app/layouts/main_page_layout.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/dot_stepper.dart';
import 'package:app/widgets/icon_button.dart';
import 'package:app/widgets/logo.dart';
import 'package:app/widgets/navbar.dart';
import 'package:app/widgets/option_slider.dart';
import 'package:app/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:gap/gap.dart';

class WidgetTest extends StatefulWidget {
  const WidgetTest({super.key});

  @override
  State<WidgetTest> createState() => _WidgetTestState();
}

class _WidgetTestState extends State<WidgetTest> {
  final _controller = TextEditingController();

  int _currentLevelIndex = 3;
  final List<String> _levels = ['A', 'B', 'C', 'D', 'E', 'F'];

  int _currentDotStepperIndex = 1;
  final _dotStepperAmount = 6;

  @override
  Widget build(BuildContext context) {
    return MainPageLayout(
      body: Column(
        crossAxisAlignment: .start,
        spacing: 20,
        children: [
          Wrap(
            runSpacing: 20,
            spacing: 20,
            children: [
              Logo.univBlack(height: 92),
              Container(
                color: Colors.black,
                child: Logo.univWhite(height: 92),
              ),
            ],
          ),
          Title(title: 'Normal title'),
          Title(title: 'Centered title', decorationAlignment: .center),
          Button.primary(text: 'Primary', onPressed: () {}),
          Button.secondary(text: 'Secondary', onPressed: () {}),
          Button.inverted(text: 'Inverted', onPressed: () {}),
          Button.outlined(text: 'Outlined', onPressed: () {}),
          PrimaryIconButton(
            icon: Icons.arrow_forward_ios,
            onPressed: () {},
          ),
          TextFormField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Text form field'),
          ),
          DropdownMenu(
            hintText: 'Dropdown form field',

            expandedInsets: EdgeInsets.zero,
            requestFocusOnTap: false,

            dropdownMenuEntries: [
              DropdownMenuEntry<String>(value: 'item1', label: 'Item 1'),
              DropdownMenuEntry<String>(value: 'item2', label: 'Item 2'),
              DropdownMenuEntry<String>(value: 'item3', label: 'Item 3'),
              DropdownMenuEntry<String>(value: 'item4', label: 'Item 4'),
              DropdownMenuEntry<String>(value: 'item5', label: 'Item 5'),
            ],
            onSelected: (value) {},
          ),
          OptionSlider(
            steps: _levels,
            selectedIndex: _currentLevelIndex,
            onChanged: (int newIndex) {
              setState(() {
                _currentLevelIndex = newIndex;
              });
            },
          ),
          Row(
            mainAxisSize: .min,
            children: [
              DotStepper(
                amount: _dotStepperAmount,
                index: _currentDotStepperIndex,
              ),
              const Gap(10),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (_currentDotStepperIndex == 0) {
                      return;
                    }
                    _currentDotStepperIndex--;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    if (_currentDotStepperIndex == _dotStepperAmount) {
                      return;
                    }
                    _currentDotStepperIndex++;
                  });
                },
              ),
            ],
          ),
        ],
      )
    );
  }
}
