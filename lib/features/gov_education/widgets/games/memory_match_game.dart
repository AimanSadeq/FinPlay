import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';

class MemoryMatchGame extends StatefulWidget {
  final List<Map<String, String>> pairs; // [{term, definition}]
  final VoidCallback onComplete;
  final ValueChanged<int> onScoreUpdate;

  const MemoryMatchGame({
    super.key,
    required this.pairs,
    required this.onComplete,
    required this.onScoreUpdate,
  });

  @override
  State<MemoryMatchGame> createState() => _MemoryMatchGameState();
}

class _MemoryMatchGameState extends State<MemoryMatchGame> {
  late List<_MemoryCard> _cards;
  int? _firstFlippedIndex;
  int? _secondFlippedIndex;
  int _matchedCount = 0;
  int _moves = 0; // total card-flip attempts (pairs checked)
  int _score = 0;
  bool _isChecking = false;

  /// Website-matching efficiency-based scoring (max 50 points).
  /// Tiers based on number of moves vs perfect moves.
  int _calculateScore() {
    const maxScore = 50;
    final perfectMoves = widget.pairs.length; // minimum possible pair-checks
    if (_moves <= perfectMoves) return maxScore;             // 50
    if (_moves <= (perfectMoves * 1.5).ceil()) return (maxScore * 0.9).round(); // 45
    if (_moves <= perfectMoves * 2) return (maxScore * 0.8).round();            // 40
    if (_moves <= (perfectMoves * 2.5).ceil()) return (maxScore * 0.7).round(); // 35
    final efficiency = perfectMoves / _moves;
    return (maxScore * efficiency).round().clamp((maxScore * 0.5).round(), maxScore); // floor 25
  }

  @override
  void initState() {
    super.initState();
    _initCards();
  }

  void _initCards() {
    _cards = [];
    for (int i = 0; i < widget.pairs.length; i++) {
      _cards.add(_MemoryCard(id: i, text: widget.pairs[i]['term']!, isTerm: true));
      _cards.add(_MemoryCard(id: i, text: widget.pairs[i]['definition']!, isTerm: false));
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Matched: $_matchedCount/${widget.pairs.length}',
              style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Moves: $_moves',
                style: const TextStyle(color: AppColors.accentLight, fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _cards.length <= 8 ? 2 : 3,
            mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1.4,
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
                            style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w500,
                              color: card.isTerm ? AppColors.primaryLight : AppColors.secondaryLight,
                            ),
                            textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis)
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
