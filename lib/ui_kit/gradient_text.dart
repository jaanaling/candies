import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final bool isCenter;
  const GradientText(
      this.text, {
        required this.fontSize,
        this.isCenter = false,
        super.key, this.gradientColors,
      });

  final String text;
  final double fontSize;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: gradientColors?? [
        Color(0xFF4EE4FF),
        Color(0xFF1989C5),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Stack(
      children: [
        Text(
          text,
          textAlign: isCenter ? TextAlign.center : null,
          style: TextStyle(
            color: Colors.transparent,
            fontSize: fontSize,
            fontFamily: 'Kizard',
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0), // Смещение тени
                color: Color(0x80000000), // Цвет тени с прозрачностью
                blurRadius: 4.0, // Радиус размытия тени
              ),
            ],
          ),
        ),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => gradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            text,
            textAlign: isCenter ? TextAlign.center : null,
            style: TextStyle(
              color: Color(0xFF1989C5),
              fontSize: fontSize,
              fontFamily: 'Kizard',
            ),
          ),
        ),
      ],
    );
  }
}