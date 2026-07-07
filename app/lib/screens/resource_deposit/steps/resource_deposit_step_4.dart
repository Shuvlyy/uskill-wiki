import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/form/resource_deposit_form.dart';
import 'package:app/widgets/labeled_dropdown_menu.dart';
import 'package:app/widgets/option_slider.dart';
import 'package:flutter/material.dart';

class ResourceDepositStep4 extends StatefulWidget {
  final ResourceDepositForm formModal;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ResourceDepositStep4({
    required this.formModal,
    required this.onNext,
    required this.onBack,
    super.key,
  });

  @override
  State<ResourceDepositStep4> createState() => _ResourceDepositStep4State();
}

class _ResourceDepositStep4State extends State<ResourceDepositStep4> {
  String _selectedLanguage = '';
  String? _error;

  int _currentLevelIndex = -1;
  final List<String> _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  @override
  void initState() {
    _selectedLanguage = widget.formModal.language;
    _currentLevelIndex = widget.formModal.languageLevel;
    super.initState();
  }

  void _next() {
    if (_selectedLanguage.isEmpty || _currentLevelIndex == -1) {
      setState(() {
        _error = 'Veuillez sélectionner une langue et un niveau.';
      });
      return;
    }

    widget.formModal.language = _selectedLanguage;
    widget.formModal.languageLevel = _currentLevelIndex;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return ResourceDepositFormStepLayout(
      title: 'Langue',
      pageIndex: 3,
      onNext: _next,
      onBack: widget.onBack,
      showMandatoryFieldsWarning: true,
      errorMessage: _error,
      body: Column(
        spacing: 20,
        children: [
          LabeledDropdownMenu(
            label: 'Langue',
            hintText: 'Langue',
            initialSelection: widget.formModal.language,

            dropdownMenuEntries: [
              DropdownMenuEntry(value: 'fr', label: 'Français'),
              DropdownMenuEntry(value: 'en', label: 'English'),
              DropdownMenuEntry(value: 'es', label: 'Español'),
            ],
            onSelected: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _selectedLanguage = value;
                _error = null;
              });
            },
          ),
          OptionSlider(
            label: 'Niveau de langue',
            steps: _levels,
            selectedIndex: _currentLevelIndex,
            onChanged: (int newIndex) {
              setState(() {
                _currentLevelIndex = newIndex;
                _error = null;
              });
            },
          ),
        ],
      ),
    );
  }
}
