import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  final double indicatorHeight;
  final double indicatorWidth;
  final Color color;
  final double borderRadius;
  final BoxShadow? boxShadow;

  const CustomTabIndicator({
    this.indicatorHeight = 8,
    this.indicatorWidth = 40,
    required this.color,
    this.borderRadius = 12,
    this.boxShadow,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    final paint = Paint()
      ..color = decoration.color
      ..style = PaintingStyle.fill;
    // ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);

    if (decoration.boxShadow != null) {
      final shadowPaint = Paint()
        ..color = decoration.boxShadow!.color
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, decoration.boxShadow!.blurRadius);

      final shadowRect = Rect.fromLTWH(
        offset.dx +
            (config.size!.width - decoration.indicatorWidth) / 2 +
            decoration.boxShadow!.offset.dx,
        offset.dy + decoration.boxShadow!.offset.dy,
        decoration.indicatorWidth,
        decoration.indicatorHeight,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
            shadowRect, Radius.circular(decoration.borderRadius)),
        shadowPaint,
      );
    }

    final rect = Rect.fromLTWH(
      offset.dx + (config.size!.width - decoration.indicatorWidth) / 2,
      offset.dy, // Draw at the **top** of the tab
      decoration.indicatorWidth,
      decoration.indicatorHeight,
    );

    final rRect =
        RRect.fromRectAndRadius(rect, Radius.circular(decoration.borderRadius));

    canvas.drawRRect(rRect, paint);
  }
}
