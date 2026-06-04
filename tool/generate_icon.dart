// Run from finplay_flutter/: dart run tool/generate_icon.dart
// Then run: dart run flutter_launcher_icons

import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

void main() {
  print('Generating FinPlay app icon...\n');

  const size = 1024;

  final icon = _createAppIcon(size);
  File('assets/icons/app_icon.png').writeAsBytesSync(img.encodePng(icon));
  print('  Saved: assets/icons/app_icon.png');

  final fg = _createAdaptiveForeground(size);
  File('assets/icons/app_icon_adaptive_fg.png').writeAsBytesSync(img.encodePng(fg));
  print('  Saved: assets/icons/app_icon_adaptive_fg.png');

  print('\nDone! Now run: dart run flutter_launcher_icons');
}

// ═══════════════════════════════════════════════════════════════
// Main icon
// ═══════════════════════════════════════════════════════════════
img.Image _createAppIcon(int size) {
  final image = img.Image(width: size, height: size);
  final s = size.toDouble();
  final cornerR = (s * 0.22).round();

  // ── 1. Gradient background ──
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      if (!_inRoundedRect(x, y, size, size, cornerR)) {
        image.setPixelRgba(x, y, 0, 0, 0, 0);
        continue;
      }
      // Diagonal gradient: deep navy → royal blue → indigo
      final t = ((x / s) * 0.4 + (y / s) * 0.6).clamp(0.0, 1.0);
      final r = _lerp3(0x0C, 0x1A, 0x38, t);
      final g = _lerp3(0x12, 0x2D, 0x1A, t);
      final b = _lerp3(0x35, 0x7A, 0x8C, t);
      image.setPixelRgba(x, y, r, g, b, 255);
    }
  }

  // ── 2. Subtle ambient glows ──
  _radialGlow(image, size, cornerR, 0.25, 0.20, 0.55, 0x38, 0x6B, 0xF4, 0.10);
  _radialGlow(image, size, cornerR, 0.75, 0.80, 0.45, 0x8B, 0x5C, 0xF6, 0.08);

  // ── 3. Draw the creative icon ──
  _drawIconContent(image, size, cornerR, 0.0);

  return image;
}

img.Image _createAdaptiveForeground(int size) {
  final image = img.Image(width: size, height: size);
  // Transparent base
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      image.setPixelRgba(x, y, 0, 0, 0, 0);
    }
  }
  _drawIconContent(image, size, 0, 0.15);
  return image;
}

void _drawIconContent(img.Image image, int size, int cornerR, double padding) {
  final s = size.toDouble();
  final pad = s * padding;
  final scale = (s - pad * 2) / s;
  final ox = pad;
  final oy = pad;

  // ─────────────────────────────────────────
  // Design: 5 ascending bars in vibrant gradient
  // with a glowing upward trend arrow overlay
  // and a play-triangle accent
  // ─────────────────────────────────────────

  final barCount = 5;
  final barAreaLeft = ox + s * 0.14 * scale;
  final barAreaRight = ox + s * 0.86 * scale;
  final barAreaBottom = oy + s * 0.72 * scale;
  final barAreaWidth = barAreaRight - barAreaLeft;
  final barWidth = barAreaWidth / barCount * 0.58;
  final barGap = barAreaWidth / barCount * 0.42;
  final totalBarSpace = barWidth * barCount + barGap * (barCount - 1);
  final barStartX = barAreaLeft + (barAreaWidth - totalBarSpace) / 2;

  // Bar heights (ascending with slight variation for organic feel)
  final barHeights = [0.22, 0.35, 0.30, 0.50, 0.68];

  // Bar colors: cyan → blue → indigo → violet → purple
  final barColors = [
    [0x06, 0xD6, 0xA0], // emerald/teal
    [0x38, 0xBD, 0xF8], // sky blue
    [0x60, 0xA5, 0xFA], // blue
    [0x81, 0x8C, 0xF8], // indigo
    [0xA7, 0x8B, 0xFA], // violet
  ];

  // Draw each bar with rounded top, gradient fill, and glow
  for (int i = 0; i < barCount; i++) {
    final bx = barStartX + i * (barWidth + barGap);
    final bh = s * barHeights[i] * scale;
    final by = barAreaBottom - bh;
    final bw = barWidth;
    final br = bw * 0.30; // top corner radius

    final cr = barColors[i][0];
    final cg = barColors[i][1];
    final cb = barColors[i][2];

    // Glow behind bar
    _drawBarGlow(image, size, cornerR, bx, by, bw, bh, cr, cg, cb, 0.20);

    // Main bar with vertical gradient (lighter top → color → slightly darker bottom)
    _drawGradientBar(image, size, cornerR, bx, by, bw, bh, br, cr, cg, cb);

    // Shine highlight on left edge of bar
    _drawBarShine(image, size, cornerR, bx, by, bw * 0.35, bh, br);
  }

  // ── Trend line connecting bar tops ──
  final linePoints = <List<double>>[];
  for (int i = 0; i < barCount; i++) {
    final bx = barStartX + i * (barWidth + barGap) + barWidth / 2;
    final bh = s * barHeights[i] * scale;
    final by = barAreaBottom - bh;
    linePoints.add([bx, by - s * 0.015 * scale]);
  }

  // Draw smooth trend line
  final lineW = (s * 0.006).round().clamp(3, 8);
  for (int i = 0; i < linePoints.length - 1; i++) {
    _drawSmoothLine(image, size, cornerR,
      linePoints[i][0].round(), linePoints[i][1].round(),
      linePoints[i + 1][0].round(), linePoints[i + 1][1].round(),
      lineW, 255, 255, 255, 180);
  }

  // Glowing dot at the peak (last bar top)
  final peakX = linePoints.last[0].round();
  final peakY = linePoints.last[1].round();
  final dotR = (s * 0.022).round();

  // Outer glow
  _drawSoftCircle(image, size, cornerR, peakX, peakY, dotR * 3,
    0x34, 0xD3, 0x99, 80);
  // Mid glow
  _drawSoftCircle(image, size, cornerR, peakX, peakY, dotR * 2,
    0x34, 0xD3, 0x99, 120);
  // Core dot
  _fillCircle(image, size, cornerR, peakX, peakY, dotR,
    0x34, 0xD3, 0x99, 255);
  // White center
  _fillCircle(image, size, cornerR, peakX, peakY, (dotR * 0.4).round(),
    255, 255, 255, 220);

  // ── Small upward arrow above the peak dot ──
  final arrowSize = (s * 0.04 * scale).round();
  final arrowX = peakX;
  final arrowY = peakY - dotR * 2 - arrowSize;
  _drawArrowUp(image, size, cornerR, arrowX, arrowY, arrowSize,
    0x34, 0xD3, 0x99, 200);

  // ── Play triangle accent (bottom-right area) ──
  final triSize = s * 0.07 * scale;
  final triCx = ox + s * 0.82 * scale;
  final triCy = oy + s * 0.82 * scale;
  _drawPlayTriangle(image, size, cornerR, triCx, triCy, triSize,
    255, 255, 255, 50);

  // ── Sparkle accents ──
  _drawSparkle(image, size, cornerR,
    (ox + s * 0.18 * scale).round(), (oy + s * 0.18 * scale).round(),
    (s * 0.025).round(), 255, 255, 255, 100);
  _drawSparkle(image, size, cornerR,
    (ox + s * 0.85 * scale).round(), (oy + s * 0.30 * scale).round(),
    (s * 0.015).round(), 255, 255, 255, 60);
}

// ═══════════════════════════════════════════════════════════════
// Drawing helpers
// ═══════════════════════════════════════════════════════════════

int _lerp(int a, int b, double t) => (a + (b - a) * t).round().clamp(0, 255);

int _lerp3(int a, int b, int c, double t) {
  if (t < 0.5) return _lerp(a, b, t * 2);
  return _lerp(b, c, (t - 0.5) * 2);
}

bool _inRoundedRect(int x, int y, int w, int h, int r) {
  if (r <= 0) return x >= 0 && x < w && y >= 0 && y < h;
  if (x < r && y < r) return _dist(x, y, r, r) <= r;
  if (x >= w - r && y < r) return _dist(x, y, w - r - 1, r) <= r;
  if (x < r && y >= h - r) return _dist(x, y, r, h - r - 1) <= r;
  if (x >= w - r && y >= h - r) return _dist(x, y, w - r - 1, h - r - 1) <= r;
  return true;
}

double _dist(int x1, int y1, int x2, int y2) {
  return sqrt(((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)).toDouble());
}

void _blend(img.Image image, int x, int y, int r, int g, int b, int a,
    [int cornerR = 0]) {
  if (x < 0 || x >= image.width || y < 0 || y >= image.height) return;
  if (cornerR > 0 && !_inRoundedRect(x, y, image.width, image.height, cornerR)) return;
  if (a <= 0) return;

  final p = image.getPixel(x, y);
  final ea = p.a.toInt();
  if (ea == 0 && cornerR > 0) return; // outside rounded rect

  final alpha = a / 255.0;
  final inv = 1.0 - alpha;
  image.setPixelRgba(x, y,
    (r * alpha + p.r.toInt() * inv).round().clamp(0, 255),
    (g * alpha + p.g.toInt() * inv).round().clamp(0, 255),
    (b * alpha + p.b.toInt() * inv).round().clamp(0, 255),
    min(255, ea + a),
  );
}

void _radialGlow(img.Image image, int size, int cornerR,
    double cx, double cy, double radius, int r, int g, int b, double maxA) {
  final cxP = (size * cx).round();
  final cyP = (size * cy).round();
  final rP = (size * radius).round();
  for (int y = max(0, cyP - rP); y < min(size, cyP + rP); y++) {
    for (int x = max(0, cxP - rP); x < min(size, cxP + rP); x++) {
      final d = _dist(x, y, cxP, cyP);
      if (d < rP) {
        final t = 1.0 - d / rP;
        _blend(image, x, y, r, g, b, (t * t * maxA * 255).round(), cornerR);
      }
    }
  }
}

void _fillCircle(img.Image image, int size, int cornerR,
    int cx, int cy, int radius, int r, int g, int b, int a) {
  for (int y = max(0, cy - radius); y <= min(size - 1, cy + radius); y++) {
    for (int x = max(0, cx - radius); x <= min(size - 1, cx + radius); x++) {
      if (_dist(x, y, cx, cy) <= radius) {
        _blend(image, x, y, r, g, b, a, cornerR);
      }
    }
  }
}

void _drawSoftCircle(img.Image image, int size, int cornerR,
    int cx, int cy, int radius, int r, int g, int b, int maxA) {
  for (int y = max(0, cy - radius); y <= min(size - 1, cy + radius); y++) {
    for (int x = max(0, cx - radius); x <= min(size - 1, cx + radius); x++) {
      final d = _dist(x, y, cx, cy);
      if (d <= radius) {
        final t = 1.0 - d / radius;
        _blend(image, x, y, r, g, b, (t * t * maxA).round(), cornerR);
      }
    }
  }
}

void _drawGradientBar(img.Image image, int size, int cornerR,
    double x, double y, double w, double h, double topR,
    int cr, int cg, int cb) {
  final ix = x.round();
  final iy = y.round();
  final iw = w.round();
  final ih = h.round();
  final ir = topR.round();

  for (int py = iy; py < iy + ih; py++) {
    for (int px = ix; px < ix + iw; px++) {
      if (px < 0 || px >= size || py < 0 || py >= size) continue;
      if (cornerR > 0 && !_inRoundedRect(px, py, size, size, cornerR)) continue;

      // Check rounded top corners
      final localX = px - ix;
      final localY = py - iy;
      if (localY < ir) {
        if (localX < ir && _dist(localX, localY, ir, ir) > ir) continue;
        if (localX >= iw - ir && _dist(localX, localY, iw - ir - 1, ir) > ir) continue;
      }

      // Vertical gradient: lighter top → main color → slightly darker bottom
      final t = localY / ih;
      int r, g, b;
      if (t < 0.15) {
        // Top highlight
        final lt = t / 0.15;
        r = _lerp(min(255, cr + 70), cr, lt);
        g = _lerp(min(255, cg + 70), cg, lt);
        b = _lerp(min(255, cb + 50), cb, lt);
      } else if (t < 0.85) {
        r = cr; g = cg; b = cb;
      } else {
        // Bottom darken
        final lt = (t - 0.85) / 0.15;
        r = _lerp(cr, max(0, cr - 30), lt);
        g = _lerp(cg, max(0, cg - 30), lt);
        b = _lerp(cb, max(0, cb - 20), lt);
      }

      _blend(image, px, py, r, g, b, 245, cornerR);
    }
  }
}

void _drawBarGlow(img.Image image, int size, int cornerR,
    double x, double y, double w, double h,
    int cr, int cg, int cb, double intensity) {
  final cx = (x + w / 2).round();
  final cy = (y + h / 2).round();
  final rr = (max(w, h) * 0.8).round();

  for (int py = max(0, cy - rr); py < min(size, cy + rr); py++) {
    for (int px = max(0, cx - rr); px < min(size, cx + rr); px++) {
      final d = _dist(px, py, cx, cy);
      if (d < rr) {
        final t = 1.0 - d / rr;
        _blend(image, px, py, cr, cg, cb, (t * t * intensity * 255).round(), cornerR);
      }
    }
  }
}

void _drawBarShine(img.Image image, int size, int cornerR,
    double x, double y, double w, double h, double topR) {
  final ix = x.round();
  final iy = y.round();
  final iw = w.round();
  final ih = h.round();
  final ir = topR.round();

  for (int py = iy; py < iy + ih; py++) {
    for (int px = ix; px < ix + iw; px++) {
      if (px < 0 || px >= size || py < 0 || py >= size) continue;
      if (cornerR > 0 && !_inRoundedRect(px, py, size, size, cornerR)) continue;

      final localX = px - ix;
      final localY = py - iy;

      // Check rounded top-left corner
      if (localY < ir && localX < ir && _dist(localX, localY, ir, ir) > ir) continue;

      // Horizontal fade
      final ht = 1.0 - (localX / iw);
      // Vertical fade (stronger at top)
      final vt = 1.0 - (localY / ih) * 0.5;
      final alpha = (ht * ht * vt * 0.25 * 255).round();

      if (alpha > 2) {
        _blend(image, px, py, 255, 255, 255, alpha, cornerR);
      }
    }
  }
}

void _drawSmoothLine(img.Image image, int size, int cornerR,
    int x1, int y1, int x2, int y2, int width,
    int r, int g, int b, int a) {
  final dx = (x2 - x1).abs();
  final dy = (y2 - y1).abs();
  final steps = max(dx, dy);
  if (steps == 0) return;

  for (int i = 0; i <= steps; i++) {
    final t = i / steps;
    final cx = x1 + ((x2 - x1) * t).round();
    final cy = y1 + ((y2 - y1) * t).round();
    final hw = width ~/ 2;
    for (int dy2 = -hw; dy2 <= hw; dy2++) {
      for (int dx2 = -hw; dx2 <= hw; dx2++) {
        final d = sqrt((dx2 * dx2 + dy2 * dy2).toDouble());
        if (d <= hw) {
          // Anti-alias at edges
          final edgeAlpha = d > hw - 1 ? (hw - d).clamp(0.0, 1.0) : 1.0;
          _blend(image, cx + dx2, cy + dy2, r, g, b,
            (a * edgeAlpha).round(), cornerR);
        }
      }
    }
  }
}

void _drawArrowUp(img.Image image, int size, int cornerR,
    int cx, int cy, int arrowSize, int r, int g, int b, int a) {
  // Simple upward chevron/arrow
  final halfW = arrowSize;
  final h = (arrowSize * 0.7).round();
  final thickness = (arrowSize * 0.35).round();

  for (int i = 0; i <= halfW; i++) {
    final yOff = (i * h / halfW).round();
    // Left side
    _drawSmoothLine(image, size, cornerR,
      cx - i, cy + yOff, cx - i, cy + yOff, thickness, r, g, b, a);
    // Right side
    _drawSmoothLine(image, size, cornerR,
      cx + i, cy + yOff, cx + i, cy + yOff, thickness, r, g, b, a);
  }
}

void _drawPlayTriangle(img.Image image, int size, int cornerR,
    double cx, double cy, double triSize, int r, int g, int b, int a) {
  // Play button triangle pointing right
  final h = triSize;
  final w = triSize * 0.866; // equilateral proportions

  for (int py = (cy - h).round(); py <= (cy + h).round(); py++) {
    for (int px = (cx - w * 0.4).round(); px <= (cx + w * 0.6).round(); px++) {
      if (px < 0 || px >= size || py < 0 || py >= size) continue;

      // Check if point is inside triangle
      final localX = px - cx;
      final localY = py - cy;

      // Triangle: left vertex (-w*0.4, 0), top-right (w*0.6, -h), bottom-right (w*0.6, h)
      // Simplified: point is inside if localX >= -w*0.4 and within the diagonal bounds
      final maxYAtX = h * (localX + w * 0.4) / w;
      if (localX >= -w * 0.4 && localX <= w * 0.6 &&
          localY.abs() <= maxYAtX) {
        _blend(image, px, py, r, g, b, a, cornerR);
      }
    }
  }
}

void _drawSparkle(img.Image image, int size, int cornerR,
    int cx, int cy, int sparkleR, int r, int g, int b, int a) {
  // 4-pointed star sparkle
  // Horizontal line
  for (int i = -sparkleR; i <= sparkleR; i++) {
    final t = 1.0 - (i.abs() / sparkleR);
    final alpha = (t * t * a).round();
    _blend(image, cx + i, cy, r, g, b, alpha, cornerR);
    if (t > 0.7) {
      _blend(image, cx + i, cy - 1, r, g, b, (alpha * 0.3).round(), cornerR);
      _blend(image, cx + i, cy + 1, r, g, b, (alpha * 0.3).round(), cornerR);
    }
  }
  // Vertical line
  for (int i = -sparkleR; i <= sparkleR; i++) {
    final t = 1.0 - (i.abs() / sparkleR);
    final alpha = (t * t * a).round();
    _blend(image, cx, cy + i, r, g, b, alpha, cornerR);
    if (t > 0.7) {
      _blend(image, cx - 1, cy + i, r, g, b, (alpha * 0.3).round(), cornerR);
      _blend(image, cx + 1, cy + i, r, g, b, (alpha * 0.3).round(), cornerR);
    }
  }
  // Core glow
  _drawSoftCircle(image, size, cornerR, cx, cy, (sparkleR * 0.4).round(),
    r, g, b, a);
}
