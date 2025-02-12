import 'package:flutter/material.dart';
import 'package:gym_journal_app/Themes/theme.dart';

class WavePainter extends CustomPainter {
  final double waveHeightFactor; // Controls how far down the wave appears
  num? peakOffset; // Controls the peak/trough variation

  WavePainter({required this.waveHeightFactor, this.peakOffset});

  @override
  void paint(Canvas canvas, Size size) {
    peakOffset = peakOffset == null ? 0.05 : peakOffset;
    final paint = Paint()
      ..color = primaryThemeColour
      ..style = PaintingStyle.fill;

    final path = Path()
      ..lineTo(0, size.height * waveHeightFactor)
      ..quadraticBezierTo(
          size.width * 0.25, size.height * (waveHeightFactor + peakOffset!),
          size.width * 0.5, size.height * waveHeightFactor)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * (waveHeightFactor - peakOffset!),
          size.width, size.height * waveHeightFactor)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
