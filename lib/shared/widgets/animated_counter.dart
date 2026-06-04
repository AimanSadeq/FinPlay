import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedCounter extends StatelessWidget {
  final double value;
  final String? prefix;
  final String? suffix;
  final int decimals;
  final TextStyle? style;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.prefix,
    this.suffix,
    this.decimals = 0,
    this.style,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        String formatted;
        if (decimals > 0) {
          formatted = animatedValue.toStringAsFixed(decimals);
        } else {
          formatted = animatedValue.toInt().toString();
        }

        // Add thousand separators
        final parts = formatted.split('.');
        final intPart = parts[0].replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
        formatted = parts.length > 1 ? '$intPart.${parts[1]}' : intPart;

        return Text(
          '${prefix ?? ''}$formatted${suffix ?? ''}',
          style: style ?? GoogleFonts.jetBrainsMono(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      },
    );
  }
}
