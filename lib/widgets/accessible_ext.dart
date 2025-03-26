import 'package:flutter/material.dart';

class Accessible extends StatelessWidget {
  final Widget child;
  final String? label;
  final String? hint;
  final bool? isButton;
  final bool? isHeader;
  final bool? isSelected;
  final bool? isEnabled;

  const Accessible({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.isButton,
    this.isHeader,
    this.isSelected,
    this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton ?? false,
      header: isHeader ?? false,
      selected: isSelected,
      enabled: isEnabled,
      child: child,
    );
  }
}

// 🔽 Add this extension below
extension AccessibleExtension on Widget {
  Widget accessible({
    String? label,
    String? hint,
    bool? isButton,
    bool? isHeader,
    bool? isSelected,
    bool? isEnabled,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton ?? false,
      header: isHeader ?? false,
      selected: isSelected,
      enabled: isEnabled,
      child: this,
    );
  }
}
