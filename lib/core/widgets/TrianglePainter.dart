import 'package:flutter/widgets.dart';

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double newWidth = size.width * 0.6; // Reduce width to 60% of original

    Paint fillPaint = Paint()
      ..color = const Color(0xFF16CA8B).withOpacity(0.2) // Green fill color
      ..style = PaintingStyle.fill;

    Paint borderPaint = Paint()
      ..color = const Color(0xFF16CA8B) // Green border color
      ..strokeWidth = 1 // Adjust border thickness
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(size.width, 0); // Top right corner
    path.lineTo(
        size.width - newWidth, size.height / 2); // Move bottom left closer
    path.lineTo(size.width, size.height); // Bottom right stays the same
    path.close();

    canvas.drawPath(path, fillPaint); // Fill the triangle
    canvas.drawPath(path, borderPaint); // Draw the border
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
