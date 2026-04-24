import 'package:evana_event_management_app/Helpers/app_theme.dart';
import 'package:flutter/material.dart';

class FestiveLogo extends StatelessWidget {
  const FestiveLogo({
    super.key,
    this.size = 160,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _FestiveLogoPainter(),
      ),
    );
  }
}

class _FestiveLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.08;

    final glowPaint = Paint()
      ..color = AppTheme.primary.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    canvas.drawCircle(center, size.width * 0.34, glowPaint);

    final ePath = Path()
      ..moveTo(size.width * 0.35, size.height * 0.22)
      ..lineTo(size.width * 0.35, size.height * 0.78)
      ..moveTo(size.width * 0.35, size.height * 0.22)
      ..lineTo(size.width * 0.68, size.height * 0.22)
      ..moveTo(size.width * 0.35, size.height * 0.5)
      ..lineTo(size.width * 0.6, size.height * 0.5)
      ..moveTo(size.width * 0.35, size.height * 0.78)
      ..lineTo(size.width * 0.68, size.height * 0.78);

    strokePaint
      ..color = Colors.white
      ..strokeWidth = size.width * 0.09;
    canvas.drawPath(ePath, strokePaint);

    final wavePath = Path()
      ..moveTo(size.width * 0.18, size.height * 0.62)
      ..cubicTo(
        size.width * 0.34,
        size.height * 0.48,
        size.width * 0.5,
        size.height * 0.9,
        size.width * 0.72,
        size.height * 0.34,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.2,
        size.width * 0.86,
        size.height * 0.14,
        size.width * 0.92,
        size.height * 0.1,
      );

    strokePaint
      ..color = AppTheme.accentAmber
      ..strokeWidth = size.width * 0.06;
    canvas.drawPath(wavePath, strokePaint);

    final sparkPaint = Paint()
      ..color = AppTheme.accentAmber
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.86, size.height * 0.14),
      size.width * 0.03,
      sparkPaint,
    );

    final sparkle = Path()
      ..moveTo(size.width * 0.86, size.height * 0.04)
      ..lineTo(size.width * 0.875, size.height * 0.11)
      ..lineTo(size.width * 0.94, size.height * 0.14)
      ..lineTo(size.width * 0.875, size.height * 0.17)
      ..lineTo(size.width * 0.86, size.height * 0.24)
      ..lineTo(size.width * 0.845, size.height * 0.17)
      ..lineTo(size.width * 0.78, size.height * 0.14)
      ..lineTo(size.width * 0.845, size.height * 0.11)
      ..close();
    canvas.drawPath(sparkle, sparkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
