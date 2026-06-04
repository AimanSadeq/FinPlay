import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';

/// Shared building blocks for the "Advanced Finance Tools" screens
/// (WACC, DuPont, Working Capital, Credit Rating, Covenants, Cap Table,
/// Dividends, Ratios). Mirrors the visual language already established in
/// capital_budgeting_screen.dart / break_even_screen.dart.

/// Standard gradient scaffold + centered title app bar used by every tool.
class ModuleScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const ModuleScaffold({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(gradient: AppColors.backgroundGradient(context)),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    trailing ?? const SizedBox(width: 48),
                  ],
                ),
              ).animate().fadeIn(),
              const SizedBox(height: 12),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

/// Two- or three-tab segmented control (e.g. Learn / Tools).
class SegmentTabBar extends StatelessWidget {
  final int activeTab;
  final List<({IconData icon, String label})> tabs;
  final ValueChanged<int> onChanged;

  const SegmentTabBar({
    super.key,
    required this.activeTab,
    required this.tabs,
    required this.onChanged,
  });

  static const _activeBlue = Color(0xFF0B5ED7);
  static const _activeBorderBlue = Color(0xFF0D6EFD);
  static const _inactiveText = Color(0xFF131B2B);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = activeTab == i;
          final tab = tabs[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: 250.ms,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isActive
                      ? (isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.white)
                      : Colors.transparent,
                  border: isActive
                      ? const Border(
                          bottom:
                              BorderSide(color: _activeBorderBlue, width: 2))
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(tab.icon,
                        size: 20,
                        color: isActive
                            ? _activeBlue
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : _inactiveText)),
                    const SizedBox(height: 2),
                    Text(
                      tab.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isActive
                            ? _activeBlue
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : _inactiveText),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Labelled slider with a formatted readout (mirrors the private _SliderRow).
class SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min, max;
  final String? prefix, suffix;
  final int? divisions;
  final int decimals;
  final ValueChanged<double> onChanged;

  const SliderRow({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.prefix,
    this.suffix,
    this.divisions,
    this.decimals = 0,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String display;
    if (value.abs() >= 1000 && decimals == 0) {
      display = '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k';
    } else {
      display = value.toStringAsFixed(decimals);
    }
    if (prefix != null) display = '$prefix$display';
    if (suffix != null) display = '$display$suffix';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              child: Text(label,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            Text(display,
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 13, color: AppColors.primaryLight)),
          ]),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            activeColor: AppColors.primaryLight,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Compact metric card with icon, big value and caption.
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? caption;
  final IconData icon;
  final Color color;
  final bool highlight;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.caption,
    required this.icon,
    required this.color,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: color.withValues(alpha: highlight ? 0.55 : 0.3),
      backgroundColor: highlight ? color.withValues(alpha: 0.08) : null,
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
              )),
          if (caption != null) ...[
            const SizedBox(height: 2),
            Text(caption!,
                style: TextStyle(
                    fontSize: 10,
                    height: 1.3,
                    color: AppColors.textTertiary(context))),
          ],
        ],
      ),
    );
  }
}

/// Coloured verdict / status banner.
class VerdictBanner extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const VerdictBanner({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          color.withValues(alpha: 0.15),
          color.withValues(alpha: 0.05),
        ]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: color)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!,
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: AppColors.textSecondary(context))),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tiny colour-bar section heading (mirrors the private _SectionLabel).
class SectionLabel extends StatelessWidget {
  final String label;
  final Color color;

  const SectionLabel({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration:
              BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 0.5)),
      ],
    );
  }
}

/// A concept "card" used in Learn tabs: icon, title, body, optional formula.
class ConceptCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String? formula;
  final Color color;

  const ConceptCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.formula,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: color.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary(context),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(body,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                height: 1.55,
                color: AppColors.textSecondary(context),
              )),
          if (formula != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Text(formula!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.6,
                    color: color,
                  )),
            ),
          ],
        ],
      ),
    );
  }
}

/// Editable numeric input row used by Tools tabs that prefer typed entry.
class NumberField extends StatelessWidget {
  final String label;
  final String? prefix;
  final String? suffix;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const NumberField({
    super.key,
    required this.label,
    this.prefix,
    this.suffix,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.right,
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 14, color: AppColors.textPrimary(context)),
              decoration: InputDecoration(
                isDense: true,
                prefixText: prefix,
                suffixText: suffix,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Currency / number formatting helper shared by the tools.
String fmtMoney(num v, {String symbol = '\$'}) {
  final neg = v < 0;
  final abs = v.abs();
  String s;
  if (abs >= 1000000) {
    s = '${(abs / 1000000).toStringAsFixed(2)}M';
  } else if (abs >= 1000) {
    s = '${(abs / 1000).toStringAsFixed(1)}k';
  } else {
    s = abs.toStringAsFixed(0);
  }
  return '${neg ? '-' : ''}$symbol$s';
}
