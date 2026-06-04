import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../providers/self_paced_provider.dart';
import '../../../providers/repository_providers.dart';
import '../../../data/self_paced_scenarios.dart';

/// Core interaction panel for self-paced mode.
/// Matches website's SelfPacedScenarioPanel exactly:
/// - Header with module name, Self-Paced badge, Move to X button, R badge
/// - 2-column grid of scenario cards with blue dashed borders
/// - Each card: title, $0 amount, description, "Add to Selection" button
/// - Confirm button and completion alerts
class SelfPacedScenarioPanel extends ConsumerStatefulWidget {
  final int round;
  final String module;
  final VoidCallback? onModuleCompleted;

  const SelfPacedScenarioPanel({
    super.key,
    required this.round,
    required this.module,
    this.onModuleCompleted,
  });

  @override
  ConsumerState<SelfPacedScenarioPanel> createState() =>
      _SelfPacedScenarioPanelState();
}

class _SelfPacedScenarioPanelState
    extends ConsumerState<SelfPacedScenarioPanel> {
  List<Map<String, dynamic>> _scenarios = [];
  Set<String> _selectedIds = {};
  Map<String, int> _amounts = {}; // scenarioId -> custom amount
  bool _isConfirmed = false;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  static const _moduleLabels = {
    'financing': 'Financing',
    'investing': 'Investment',
    'operating': 'Operating',
  };

  static const _moduleIcons = {
    'financing': Icons.account_balance_rounded,
    'investing': Icons.trending_up_rounded,
    'operating': Icons.settings_rounded,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant SelfPacedScenarioPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.round != widget.round || oldWidget.module != widget.module) {
      _loadData();
    }
  }

  String _scenarioId(Map<String, dynamic> s) {
    return (s['scenarioId'] ?? s['id'] ?? '').toString();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _isConfirmed = false;
      _selectedIds = {};
      _amounts = {};
    });

    try {
      final repo = ref.read(selfPacedRepositoryProvider);

      final results = await Future.wait([
        repo.fetchScenarios(module: widget.module, round: widget.round),
        repo.fetchDecisions(round: widget.round, module: widget.module),
      ]);

      var scenarios = results[0]
          .map((s) => s is Map<String, dynamic>
              ? s
              : Map<String, dynamic>.from(s as Map))
          .toList();

      if (scenarios.isEmpty) {
        scenarios = getFallbackScenarios(widget.round, widget.module);
      }

      final decisions = results[1]
          .map((d) => d is Map<String, dynamic>
              ? d
              : Map<String, dynamic>.from(d as Map))
          .toList();

      final existingIds = decisions
          .map((d) => d['scenarioId']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();

      // Build amounts map from scenarios
      final amountsMap = <String, int>{};
      for (final s in scenarios) {
        final id = _scenarioId(s);
        amountsMap[id] = (s['amount'] as num?)?.toInt() ?? 0;
      }

      if (mounted) {
        setState(() {
          _scenarios = scenarios;
          _selectedIds = Set.from(existingIds);
          _amounts = amountsMap;
          _isConfirmed = existingIds.isNotEmpty;
          _isLoading = false;
        });

        ref.read(selfPacedProvider.notifier).setDecisions(
          widget.module,
          decisions,
        );
      }
    } catch (e) {
      if (mounted) {
        final fallback = getFallbackScenarios(widget.round, widget.module);
        if (fallback.isNotEmpty) {
          final amountsMap = <String, int>{};
          for (final s in fallback) {
            final id = _scenarioId(s);
            amountsMap[id] = (s['amount'] as num?)?.toInt() ?? 0;
          }
          setState(() {
            _scenarios = fallback;
            _amounts = amountsMap;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _error = 'Failed to load scenarios: $e';
          });
        }
      }
    }
  }

  void _toggleScenario(String id) {
    if (_isConfirmed) return;
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  /// Confirm decisions — matches website flow:
  /// 1. Save each selected decision via POST
  /// 2. Call complete-module on backend (advances server-side state)
  /// 3. Lock this panel (isConfirmed = true)
  /// 4. For financing/investing: use backend response to advance UI to next module
  /// 5. For operating: DON'T advance UI — show celebration, user clicks "Move to X"
  Future<void> _confirmDecisions() async {
    if (_isSaving || _selectedIds.isEmpty) return;
    setState(() => _isSaving = true);

    try {
      final repo = ref.read(selfPacedRepositoryProvider);

      // Step 1: Save each selected scenario
      for (final id in _selectedIds) {
        final scenario = _scenarios.firstWhere(
          (s) => _scenarioId(s) == id,
          orElse: () => <String, dynamic>{},
        );
        await repo.saveDecision(
          round: widget.round,
          module: widget.module,
          scenarioId: id,
          data: {
            'amount': _amounts[id] ?? scenario['amount'] ?? 0,
          },
        );
      }

      // Step 2: Complete module on backend — returns the NEW state
      // Response: { success, progress: { currentRound, currentModule } }
      final response =
          await ref.read(selfPacedProvider.notifier).completeModule();
      final success = response['success'] == true;

      if (mounted) {
        // Step 3: Lock the panel
        setState(() {
          _isConfirmed = true;
          _isSaving = false;
        });

        // Store confirmed decisions for progress box display
        final confirmedDecisions = _scenarios
            .where((s) => _selectedIds.contains(_scenarioId(s)))
            .map((s) => Map<String, dynamic>.from(s))
            .toList();
        ref
            .read(selfPacedProvider.notifier)
            .setDecisions(widget.module, confirmedDecisions);

        // Step 4: For financing/investing — use the response to advance UI
        // directly (no second API call = no race condition).
        // For operating — DON'T advance, show celebration instead.
        if (success && widget.module != 'operating') {
          final progress = response['progress'] as Map<String, dynamic>?;
          if (progress != null) {
            final newRound = progress['currentRound'] as int? ?? widget.round;
            final newModule = progress['currentModule'] as String? ?? widget.module;
            ref
                .read(selfPacedProvider.notifier)
                .advanceToNextModule(newRound, newModule);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _error = 'Failed to save decisions: $e';
        });
      }
    }
  }

  /// Called when user clicks "Move to X" button (after confirming operating).
  /// Uses fetchProgress() since we don't have the response cached.
  Future<void> _moveToNext() async {
    await ref.read(selfPacedProvider.notifier).fetchProgress();
  }

  String _nextModuleLabel() {
    switch (widget.module) {
      case 'financing':
        return 'Move to Investing';
      case 'investing':
        return 'Move to Operating';
      case 'operating':
        if (widget.round < 3) return 'Move to Round ${widget.round + 1}';
        return 'Complete Game';
      default:
        return 'Next';
    }
  }

  int get _totalSelectedAmount {
    int total = 0;
    for (final id in _selectedIds) {
      total += _amounts[id] ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final label = _moduleLabels[widget.module] ?? widget.module;
    final icon = _moduleIcons[widget.module] ?? Icons.play_arrow_rounded;

    if (_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF3B82F6),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading $label scenarios...',
                style: TextStyle(color: AppColors.textSecondary(context)),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 40, color: AppColors.danger),
              const SizedBox(height: 12),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary(context))),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header: 2 rows for mobile (matches website content, adapted for narrow screens) ──
        // Row 1: Icon + "Investment Decisions" + green "Self-Paced" dot
        // Row 2: "Move to X" button + "Self-Paced" blue badge + "R1"
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Module title + Self-Paced indicator
              Row(
                children: [
                  Icon(icon, size: 22, color: const Color(0xFF1E293B)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$label Decisions',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Green pulsing dot + "Self-Paced" label
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Self-Paced',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Row 2: Move button + Self-Paced badge + Round badge
              Row(
                children: [
                  // "Move to X" button (grayed out until confirmed)
                  _MoveToButton(
                    label: _nextModuleLabel(),
                    enabled: _isConfirmed,
                    onTap: _isConfirmed ? _moveToNext : null,
                  ),
                  const Spacer(),
                  // Self-Paced blue badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_rounded,
                            size: 12, color: Colors.white),
                        SizedBox(width: 3),
                        Text(
                          'Self-Paced',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Round badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      'R${widget.round}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Selection info alert (shows when selecting, before confirm) ──
        if (!_isConfirmed && _selectedIds.isNotEmpty)
          _AlertBanner(
            color: const Color(0xFF3B82F6),
            icon: Icons.info_outline_rounded,
            text:
                '${_selectedIds.length} scenario${_selectedIds.length != 1 ? 's' : ''} selected. Total: \$${_formatAmount(_totalSelectedAmount)}',
          ),

        // ── Confirmed alert ──
        // For financing/investing: simple "locked" message (UI auto-advances)
        // For operating: celebration with "Round Complete!" + action buttons
        if (_isConfirmed && widget.module != 'operating')
          _AlertBanner(
            color: const Color(0xFF10B981),
            icon: Icons.check_circle_rounded,
            text:
                'Decisions locked. ${_selectedIds.length} scenario${_selectedIds.length != 1 ? 's' : ''} confirmed.',
          ),
        if (_isConfirmed && widget.module == 'operating')
          _OperatingCompleteAlert(
            round: widget.round,
            decisionCount: _selectedIds.length,
            onMoveToNext: _moveToNext,
          ),

        const SizedBox(height: 8),

        // ── Scenario cards — 2-column grid (matches website) ──
        if (_scenarios.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No scenarios available for $label in Round ${widget.round}.',
              style: TextStyle(color: AppColors.textSecondary(context)),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 500 ? 3 : 2;
              final spacing = 12.0;
              final cardWidth =
                  (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                      crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: _scenarios.map((scenario) {
                  final id = _scenarioId(scenario);
                  final title = scenario['title']?.toString() ?? 'Untitled';
                  final description =
                      scenario['description']?.toString() ?? '';
                  final amount = _amounts[id] ?? 0;
                  final isSelected = _selectedIds.contains(id);

                  return SizedBox(
                    width: cardWidth,
                    child: _ScenarioCard(
                      title: title,
                      description: description,
                      amount: amount,
                      isSelected: isSelected,
                      isLocked: _isConfirmed,
                      onTap: () => _toggleScenario(id),
                      onAmountChanged: (val) {
                        setState(() => _amounts[id] = val);
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),

        const SizedBox(height: 20),

        // ── Confirm button (only when not confirmed and has selections) ──
        if (!_isConfirmed)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  _isSaving || _selectedIds.isEmpty ? null : _confirmDecisions,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle_rounded, size: 18),
              label: Text(_isSaving ? 'Saving...' : 'Confirm Decisions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedIds.isNotEmpty
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF94A3B8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    final num value;
    if (amount is num) {
      value = amount;
    } else {
      value = num.tryParse(amount.toString()) ?? 0;
    }
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
    return value.toStringAsFixed(0);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// "Move to X" button (matches website: gray when disabled, green when enabled)
// ─────────────────────────────────────────────────────────────────────────────
class _MoveToButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback? onTap;

  const _MoveToButton({
    required this.label,
    required this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFF10B981).withValues(alpha: 0.1)
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled
                ? const Color(0xFF10B981).withValues(alpha: 0.3)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: enabled
                ? const Color(0xFF10B981)
                : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Alert banner (info / success style)
// ─────────────────────────────────────────────────────────────────────────────
class _AlertBanner extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;

  const _AlertBanner({
    required this.color,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Operating module completion celebration (matches website's operating alert)
// Shows "Round X Complete!" with action buttons
// ─────────────────────────────────────────────────────────────────────────────
class _OperatingCompleteAlert extends StatelessWidget {
  final int round;
  final int decisionCount;
  final VoidCallback onMoveToNext;

  const _OperatingCompleteAlert({
    required this.round,
    required this.decisionCount,
    required this.onMoveToNext,
  });

  @override
  Widget build(BuildContext context) {
    final isLastRound = round >= 3;
    final nextLabel = isLastRound ? 'Complete Game' : 'Continue to Round ${round + 1}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3B82F6).withValues(alpha: 0.08),
            const Color(0xFF8B5CF6).withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            'Round $round Complete!',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$decisionCount scenario${decisionCount != 1 ? 's' : ''} confirmed',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onMoveToNext,
              icon: Icon(
                isLastRound ? Icons.emoji_events_rounded : Icons.arrow_forward_rounded,
                size: 18,
              ),
              label: Text(nextLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Scenario card (matches website: blue dashed border, title, $amount,
// description with "Internal:" prefix, "Add to Selection" / "Selected" button)
// ─────────────────────────────────────────────────────────────────────────────
class _ScenarioCard extends StatelessWidget {
  final String title;
  final String description;
  final int amount;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;
  final ValueChanged<int> onAmountChanged;

  const _ScenarioCard({
    required this.title,
    required this.description,
    required this.amount,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF3B82F6).withValues(alpha: 0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFF93C5FD),
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + AI tooltip icon (top-right)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.auto_stories_outlined,
                  size: 16,
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.5),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Amount display: $0 with minus/edit icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$${_formatAmt(amount)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: amount > 0
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(width: 8),
                // Minus button
                _CircleIconBtn(
                  icon: Icons.remove_circle_outline_rounded,
                  color: const Color(0xFFEF4444),
                  size: 18,
                  onTap: isLocked
                      ? null
                      : () {
                          final newVal = (amount - 10000).clamp(0, 99999999);
                          onAmountChanged(newVal);
                        },
                ),
                const SizedBox(width: 4),
                // Edit button
                _CircleIconBtn(
                  icon: Icons.edit_rounded,
                  color: const Color(0xFF3B82F6),
                  size: 18,
                  onTap: isLocked ? null : () => _showAmountEditor(context),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Description (API may already include "Internal:" prefix)
            Text(
              description.startsWith('Internal:') ? description : 'Internal: $description',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // "Add to Selection" / "Selected ✓" button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isLocked ? null : onTap,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFFCBD5E1),
                  ),
                  backgroundColor: isSelected
                      ? const Color(0xFF3B82F6).withValues(alpha: 0.05)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  isSelected ? 'Selected ✓' : 'Add to Selection',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAmountEditor(BuildContext context) {
    final controller = TextEditingController(text: amount.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount (\$)',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = int.tryParse(controller.text) ?? 0;
              onAmountChanged(val.clamp(0, 99999999));
              Navigator.pop(ctx);
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  String _formatAmt(int value) {
    if (value == 0) return '0';
    // Format with commas
    final str = value.toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }
}

class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback? onTap;

  const _CircleIconBtn({
    required this.icon,
    required this.color,
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: size,
        color: onTap != null ? color : color.withValues(alpha: 0.3),
      ),
    );
  }
}
