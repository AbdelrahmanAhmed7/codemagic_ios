import 'package:flutter/rendering.dart';

class DottedRRectBorderPainter extends CustomPainter {
  DottedRRectBorderPainter({required this.color, required this.radius, this.strokeWidth = 2, this.dash = 6, this.gap = 4});
  final Color color;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dash;
        final extract = metric.extractPath(distance, next);
        canvas.drawPath(extract, paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}






















