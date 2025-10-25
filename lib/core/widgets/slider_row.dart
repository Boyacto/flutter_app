import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Slider row with label and value display
class SliderRow extends StatelessWidget {
  final String label;
  final double min;
  final double max;
  final double value;
  final String suffix;
  final ValueChanged<double> onChanged;
  final int divisions;

  const SliderRow({
    super.key,
    required this.label,
    required this.min,
    required this.max,
    required this.value,
    required this.suffix,
    required this.onChanged,
    this.divisions = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTokens.body.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              '${value.toStringAsFixed(0)}$suffix',
              style: AppTokens.body.copyWith(
                color: AppTokens.mint600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: '${value.toStringAsFixed(0)}$suffix',
          onChanged: onChanged,
        ),
      ],
    );
  }
}
