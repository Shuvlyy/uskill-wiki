import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/form/resource_deposit_form.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';

class ResourceDepositStep3 extends StatefulWidget {
  final ResourceDepositForm formModal;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ResourceDepositStep3({
    required this.formModal,
    required this.onNext,
    required this.onBack,
    super.key,
  });

  @override
  State<ResourceDepositStep3> createState() => _ResourceDepositStep3State();
}

class _ResourceDepositStep3State extends State<ResourceDepositStep3> {
  String? _error;

  void _selectType(String type) {
    setState(() {
      widget.formModal.resourceType = type;
      _error = null;
    });
  }

  void _validateAndNext() {
    if (widget.formModal.resourceType.isEmpty) {
      setState(() {
        _error = 'Veuillez sélectionner un type de ressource.';
      });
    } else {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResourceDepositFormStepLayout(
      title: 'Type de ressource',
      pageIndex: 2,
      onNext: _validateAndNext,
      onBack: widget.onBack,
      errorMessage: _error,
      body: Column(
        spacing: 20,
        children: [
          SelectableCard.horizontal(
            label: 'Exercice',
            icon: Icons.edit_note,
            isSelected: widget.formModal.resourceType == 'Exercice',
            onTap: () => _selectType('Exercice'),
          ),
          SelectableCard.horizontal(
            label: 'Vidéo',
            icon: Icons.play_circle_outline,
            isSelected: widget.formModal.resourceType == 'Vidéo',
            onTap: () => _selectType('Vidéo'),
          ),
          SelectableCard.horizontal(
            label: 'Jeu',
            icon: Icons.videogame_asset_outlined,
            isSelected: widget.formModal.resourceType == 'Jeu',
            onTap: () => _selectType('Jeu'),
          ),
          SelectableCard.horizontal(
            label: 'Article',
            icon: Icons.description_outlined,
            isSelected: widget.formModal.resourceType == 'Article',
            onTap: () => _selectType('Article'),
          ),
        ],
      ),
    );
  }
}
