import 'package:flutter/material.dart';

import '../jajan_theme.dart';

/// Ilustrasi vektor Flutter sementara; ganti dengan aset asli Agnie bila tersedia.
class WalletMascot extends StatelessWidget {
  const WalletMascot({super.key, this.size = 84});
  final double size;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _WalletPainter()),
    ),
  );
}

class _WalletPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100, size.height / 100);
    final p = Paint();
    canvas.drawOval(
      const Rect.fromLTWH(15, 89, 70, 5),
      p..color = Colors.black.withValues(alpha: .08),
    );
    canvas.drawCircle(
      const Offset(65, 20),
      17,
      p..color = const Color(0xFFE0A600),
    );
    canvas.drawCircle(const Offset(62, 18), 16, p..color = JajanColors.yellow);
    canvas.drawCircle(
      const Offset(62, 18),
      13,
      p..color = const Color(0xFFFFDD58),
    );
    canvas.drawCircle(const Offset(62, 18), 11, p..color = JajanColors.yellow);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(9, 30, 78, 58),
        const Radius.circular(16),
      ),
      p..color = const Color(0xFF1486B7),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(7, 26, 78, 58),
        const Radius.circular(16),
      ),
      p..color = JajanColors.blue,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(14, 32, 62, 5),
        const Radius.circular(4),
      ),
      p..color = const Color(0xFF6BDAFF),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(73, 43, 22, 23),
        const Radius.circular(8),
      ),
      p..color = const Color(0xFF1486B7),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(74, 43, 20, 20),
        const Radius.circular(7),
      ),
      p..color = const Color(0xFF6BDAFF),
    );
    canvas.drawCircle(const Offset(84, 53), 3, p..color = Colors.white);
    canvas.drawOval(
      const Rect.fromLTWH(34, 52, 5, 7),
      p..color = JajanColors.ink,
    );
    canvas.drawOval(const Rect.fromLTWH(55, 52, 5, 7), p);
    final smile = Path()
      ..moveTo(40, 63)
      ..quadraticBezierTo(47, 76, 54, 63);
    canvas.drawPath(
      smile,
      p
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    p.style = PaintingStyle.fill;
    canvas.drawOval(
      const Rect.fromLTWH(27, 62, 9, 4),
      p..color = const Color(0xFF75DEFF),
    );
    canvas.drawOval(const Rect.fromLTWH(60, 62, 9, 4), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
