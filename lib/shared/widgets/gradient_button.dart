import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Gradient gradient;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradient = const LinearGradient(
      colors: [Color(0xFF1A56DB), Color(0xFF3B82F6)],
    ),
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: widget.isLoading ? null : (_) {
          _controller.forward();
          HapticFeedback.lightImpact();
        },
        onTapUp: widget.isLoading ? null : (_) {
          _controller.reverse();
          widget.onPressed?.call();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.onPressed != null ? widget.gradient : null,
            color: widget.onPressed == null ? Colors.grey : null,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.onPressed != null
                ? [
                    BoxShadow(
                      color: (widget.gradient.colors.first).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          padding: widget.padding,
          child: widget.isLoading
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Confirming...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
