import 'package:flutter/material.dart';

/// A stock-exchange style ticker: [items] scroll continuously right-to-left in a loop (the
/// content is laid out twice so the loop is seamless, like the website's -50% CSS marquee).
/// Falls back to a static, swipeable row when [animate] is false, when the platform asks for
/// reduced motion, or when there is a single item. Holding a finger on it pauses the tape.
class TickerMarquee extends StatefulWidget {
  final List<Widget> items;
  final Duration loopDuration;
  final bool animate;

  const TickerMarquee({
    super.key,
    required this.items,
    this.loopDuration = const Duration(seconds: 25),
    this.animate = true,
  });

  @override
  State<TickerMarquee> createState() => _TickerMarqueeState();
}

class _TickerMarqueeState extends State<TickerMarquee> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.loopDuration);
  final _scroll = ScrollController();
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_tick);
  }

  @override
  void didUpdateWidget(covariant TickerMarquee oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loopDuration != widget.loopDuration) {
      _controller.duration = widget.loopDuration;
      if (_controller.isAnimating) _controller.repeat();
    }
  }

  void _tick() {
    if (!_scroll.hasClients) return;
    final pos = _scroll.position;
    final half = (pos.maxScrollExtent + pos.viewportDimension) / 2;
    if (half <= 0) return;
    _scroll.jumpTo((_controller.value * half).clamp(0.0, pos.maxScrollExtent));
  }

  bool _shouldAnimate(BuildContext context) =>
      widget.animate && widget.items.length > 1 && !MediaQuery.of(context).disableAnimations;

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animate = _shouldAnimate(context);
    if (animate && !_paused && !_controller.isAnimating) {
      _controller.repeat();
    } else if ((!animate || _paused) && _controller.isAnimating) {
      _controller.stop();
    }
    if (!animate) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(mainAxisSize: MainAxisSize.min, children: widget.items),
      );
    }
    // The tape always reads left-to-right (website: dir="ltr" on the marquee viewport).
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Listener(
        onPointerDown: (_) => setState(() => _paused = true),
        onPointerUp: (_) => setState(() => _paused = false),
        onPointerCancel: (_) => setState(() => _paused = false),
        child: SingleChildScrollView(
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [...widget.items, ...widget.items],
          ),
        ),
      ),
    );
  }
}
