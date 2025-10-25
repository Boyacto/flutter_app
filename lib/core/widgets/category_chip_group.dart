import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Category chip group for selecting categories
class CategoryChipGroup extends StatelessWidget {
  final List<String> options;
  final Set<String> selected;
  final bool includeMode; // true = include, false = exclude
  final ValueChanged<Set<String>> onChanged;

  const CategoryChipGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.includeMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppTokens.s8,
      runSpacing: AppTokens.s8,
      children: options.map((option) {
        final isSelected = selected.contains(option);

        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) {
            final newSelected = Set<String>.from(this.selected);
            if (selected) {
              newSelected.add(option);
            } else {
              newSelected.remove(option);
            }
            onChanged(newSelected);
          },
          selectedColor: AppTokens.navy,
          checkmarkColor: Colors.white,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          labelStyle: AppTokens.label.copyWith(
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
          ),
        );
      }).toList(),
    );
  }
}
