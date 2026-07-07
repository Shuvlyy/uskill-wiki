import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/form/resource_deposit_form.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';

class ResourceDepositStep2 extends StatefulWidget {
  final ResourceDepositForm formModal;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ResourceDepositStep2({
    required this.formModal,
    required this.onNext,
    required this.onBack,
    super.key,
  });

  @override
  State<ResourceDepositStep2> createState() => _ResourceDepositStep2State();
}

class _ResourceDepositStep2State extends State<ResourceDepositStep2> {
  String? _error;

  void _toggleTarget(String target) {
    setState(() {
      if (widget.formModal.targets.contains(target)) {
        widget.formModal.targets.remove(target);
      } else {
        widget.formModal.targets.add(target);
        _error = null;
      }
    });
  }

  void _validateAndNext() {
    if (widget.formModal.targets.isEmpty) {
      setState(() {
        _error = 'Veuillez sélectionner au moins une cible.';
      });
    } else {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResourceDepositFormStepLayout(
      title: 'Cible',
      pageIndex: 1,
      onNext: _validateAndNext,
      onBack: widget.onBack,
      errorMessage: _error,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 450;

          if (isMobile) {
            return Column(
              spacing: 20,
              children: _buildCards(),
            );
          }

          return Row(
            spacing: 20,
            children: _buildCards().map((card) => Expanded(child: card)).toList(),
          );
        },
      ),
    );
  }

  List<Widget> _buildCards() {
    return [
      SelectableCard.vertical(
        label: 'Étudiants',
        icon: Icons.school_outlined,
        isSelected: widget.formModal.targets.contains('Étudiants'),
        onTap: () => _toggleTarget('Étudiants'),
      ),
      SelectableCard.vertical(
        label: 'Enseignants',
        icon: Icons.person_outline,
        isSelected: widget.formModal.targets.contains('Enseignants'),
        onTap: () => _toggleTarget('Enseignants'),
      ),
      SelectableCard.vertical(
        label: 'Staff',
        icon: Icons.work_outline,
        isSelected: widget.formModal.targets.contains('Staff'),
        onTap: () => _toggleTarget('Staff'),
      ),
    ];
  }
}
