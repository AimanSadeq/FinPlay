import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../providers/locale_provider.dart';
import '../../modules/education_module_data.dart';

/// English term ↔ Arabic translation memory match (website MemoryMatchGame).
class MemoryMatchGame extends ConsumerStatefulWidget {
  final List<MemoryPair> pairs;
  final int maxScore;
  final VoidCallback onComplete;
  final ValueChanged<int> onScoreUpdate;

  const MemoryMatchGame({
    super.key,
    required this.pairs,
    this.maxScore = 50,
    required this.onComplete,
    required this.onScoreUpdate,
  });

  /// Website `calculateMemoryMatchScore(moves, pairs)`: efficiency tiers
  /// against the perfect run (one check per pair).
  static int scoreFor(int moves, int pairCount, [int maxScore = 50]) {
    final perfectMoves = pairCount;
    if (moves <= perfectMoves) return maxScore;
    if (moves <= perfectMoves * 1.5) return (maxScore * 0.9).round();
    if (moves <= perfectMoves * 2) return (maxScore * 0.8).round();
    if (moves <= perfectMoves * 2.5) return (maxScore * 0.7).round();
    final efficiency = perfectMoves / moves;
    final s = (maxScore * efficiency).round();
    final floor = (maxScore * 0.5).round();
    return s < floor ? floor : s;
  }

  @override
  ConsumerState<MemoryMatchGame> createState() => _MemoryMatchGameState();
}

class _MemoryMatchGameState extends ConsumerState<MemoryMatchGame> {
  late List<_MemoryCard> _cards;
  int? _firstFlippedIndex;
  int? _secondFlippedIndex;
  int _matchedCount = 0;
  int _moves = 0; // total card-flip attempts (pairs checked)
  int _score = 0;
  bool _isChecking = false;

  int _calculateScore() =>
      MemoryMatchGame.scoreFor(_moves, widget.pairs.length, widget.maxScore);

  @override
  void initState() {
    super.initState();
    _initCards();
  }

  void _initCards() {
    _cards = [];
    for (int i = 0; i < widget.pairs.length; i++) {
      _cards.add(_MemoryCard(id: i, text: widget.pairs[i].term, isTerm: true));
      _cards.add(_MemoryCard(id: i, text: widget.pairs[i].match, isTerm: false));
    }
    _cards.shuffle(Random());
  }

  void _onCardTap(int index) {
    if (_isChecking) return;
    if (_cards[index].isMatched || _cards[index].isFlipped) return;

    HapticFeedback.lightImpact();

    setState(() {
      _cards[index].isFlipped = true;

      if (_firstFlippedIndex == null) {
        _firstFlippedIndex = index;
      } else {
        _secondFlippedIndex = index;
        _moves++;
        _isChecking = true;

        final first = _cards[_firstFlippedIndex!];
        final second = _cards[_secondFlippedIndex!];

        if (first.id == second.id && first.isTerm != second.isTerm) {
          // Match!
          Future.delayed(400.ms, () {
            if (!mounted) return;
            setState(() {
              _cards[_firstFlippedIndex!].isMatched = true;
              _cards[_secondFlippedIndex!].isMatched = true;
              _matchedCount++;
              _firstFlippedIndex = null;
              _secondFlippedIndex = null;
              _isChecking = false;

              if (_matchedCount == widget.pairs.length) {
                _score = _calculateScore();
                widget.onScoreUpdate(_score);
                widget.onComplete();
              }
            });
          });
        } else {
          // No match
          Future.delayed(800.ms, () {
            if (!mounted) return;
            setState(() {
              _cards[_firstFlippedIndex!].isFlipped = false;
              _cards[_secondFlippedIndex!].isFlipped = false;
              _firstFlippedIndex = null;
              _secondFlippedIndex = null;
              _isChecking = false;
            });
          });
        }
      }
    });
  }

  void _restart() {
    setState(() {
      _initCards();
      _firstFlippedIndex = null;
      _secondFlippedIndex = null;
      _matchedCount = 0;
      _moves = 0;
      _score = 0;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ar = ref.watch(isArabicProvider);
    String t(String en, String a) => ar ? a : en;
    final done = _matchedCount == widget.pairs.length && widget.pairs.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(t('Matched: $_matchedCount/${widget.pairs.length}', 'المطابقات: $_matchedCount/${widget.pairs.length}'),
              style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(t('Moves: $_moves', 'المحاولات: $_moves'),
                style: const TextStyle(color: AppColors.accentLight, fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ],
        ),
        if (done) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Text(t('Score: $_score / ${widget.maxScore}', 'النتيجة: $_score / ${widget.maxScore}'),
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.secondaryLight)),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: _restart,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(t('Play Again', 'العب مرة أخرى')),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _cards.length <= 8 ? 2 : (_cards.length <= 24 ? 3 : 4),
            mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: _cards.length > 24 ? 0.95 : 1.4,
          ),
          itemCount: _cards.length,
          itemBuilder: (context, index) {
            final card = _cards[index];
            return GestureDetector(
              onTap: () => _onCardTap(index),
              child: AnimatedContainer(
                duration: 300.ms,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: card.isMatched
                      ? AppColors.secondary.withValues(alpha: 0.15)
                      : card.isFlipped
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.cardColor(context),
                  border: Border.all(
                    color: card.isMatched
                        ? AppColors.secondaryLight.withValues(alpha: 0.5)
                        : card.isFlipped
                            ? AppColors.primaryLight.withValues(alpha: 0.5)
                            : AppColors.borderColor(context),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: card.isFlipped || card.isMatched
                        ? Text(card.text,
                            textDirection: card.isTerm ? TextDirection.ltr : TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w500,
                              color: card.isTerm ? AppColors.primaryLight : AppColors.secondaryLight,
                            ),
                            textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis)
                        : Icon(Icons.help_outline_rounded,
                            color: AppColors.textTertiary(context).withValues(alpha: 0.5), size: 24),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MemoryCard {
  final int id;
  final String text;
  final bool isTerm;
  bool isFlipped;
  bool isMatched;

  _MemoryCard({
    required this.id,
    required this.text,
    required this.isTerm,
  }) : isFlipped = false,
       isMatched = false;
}
