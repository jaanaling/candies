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

class TextWithBorder extends StatelessWidget {
  final String text;
  final Color borderColor;
  final Color? color;
  final double fontSize;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final String? fontFamily;
  final double? height;
  final TextOverflow? overflow;

  const TextWithBorder({
    super.key,
    required this.text,
    required this.borderColor,
    required this.fontSize,
    this.letterSpacing,
    this.textAlign,
    this.fontFamily,
    this.color,
    this.overflow, this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          textAlign: textAlign,
          overflow: overflow,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            height: height,
            letterSpacing: letterSpacing,
            shadows: [
              Shadow(
                offset: Offset(3.0, 3.0), // Смещение тени
                color: Color(0x80000000), // Цвет тени с прозрачностью
                blurRadius: 4,
              ),
            ],
            fontFamily: fontFamily ?? 'Florida',

            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 5
              ..color = borderColor,
          ),
        ),
        Text(
          text,
          textAlign: textAlign,
          overflow: overflow,
          style: TextStyle(
            fontSize: fontSize,
            height: height,
            fontWeight: FontWeight.w400,
            letterSpacing: letterSpacing,
            fontFamily: fontFamily ?? 'Florida',
            color: color ?? Colors.white,

          ),
        ),
      ],
    );
  }
}