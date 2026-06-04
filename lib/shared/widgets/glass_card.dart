import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final Color? borderColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Gradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.blur = 10,
    this.borderColor,
    this.backgroundColor,
    this.onTap,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.white.withValues(alpha: 0.85);
    final defaultBorder = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : const Color(0xFFE2E8F0);

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient,
                color: gradient == null ? (backgroundColor ?? defaultBg) : null,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: borderColor ?? defaultBorder,
                  width: 1,
                ),
              ),
              padding: padding ?? const EdgeInsets.all(20),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
