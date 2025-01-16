import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final ButtonColors color;
  final Widget widget;
  final VoidCallback? onPressed;
  final double radius;
  final double? width;

  const AppButton({
    super.key,
    required this.color,
    required this.widget,
    this.onPressed,
    this.radius = 19,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        splashColor: color == ButtonColors.green
            ? const Color(0xFFa2fb6d)
            : color == ButtonColors.blue
                ? const Color(0xFF6dbbfb)
                : color == ButtonColors.lightBlue
                    ? const Color(0xFF6df7eb)
                    : color == ButtonColors.red
                        ? const Color(0xFFfb6d6d)
                        : const Color(0xFFf86dac),
        // onPressed: onPressed,
        // padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Ink(
            width: width,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color == ButtonColors.green
                      ? const Color(0xFFa2fb6d)
                      : color == ButtonColors.blue
                          ? const Color(0xFF6dbbfb)
                          : color == ButtonColors.lightBlue
                              ? const Color(0xFF6df7eb)
                              : color == ButtonColors.red
                                  ? const Color(0xFFfb6d6d)
                                  : const Color(0xFFf86dac),
                  color == ButtonColors.green
                      ? const Color(0xFF23a909)
                      : color == ButtonColors.blue
                          ? const Color(0xFF076ea8)
                          : color == ButtonColors.lightBlue
                              ? const Color(0xFF0765a8)
                              : color == ButtonColors.red
                                  ? const Color(0xFFa20707)
                                  : const Color(0xFFad086c),
                ],
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: color == ButtonColors.green
                      ? const Color(0xFF00590A)
                      : color == ButtonColors.blue
                          ? const Color(0xFF003C59)
                          : color == ButtonColors.lightBlue
                              ? const Color(0xFF003459)
                              : color == ButtonColors.red
                                  ? const Color(0xFF590000)
                                  : const Color(0xFF590027),
                ),
                borderRadius: BorderRadius.circular(radius),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Ink(
                width: width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: color == ButtonColors.green
                        ? [const Color(0xFF6FFB18), const Color(0xFF2BC408)]
                        : color == ButtonColors.blue
                            ? [const Color(0xFF1894FB), const Color(0xFF088BC4)]
                            : color == ButtonColors.lightBlue
                                ? [
                                    const Color(0xFF18FBE0),
                                    const Color(0xFF0875C4)
                                  ]
                                : color == ButtonColors.red
                                    ? [
                                        const Color(0xFFFB1818),
                                        const Color(0xFFC40808),
                                      ]
                                    : [
                                        const Color(0xFFF8187B),
                                        const Color(0xFFC90A7F),
                                      ],
                  ),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: widget,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum ButtonColors { green, red, blue, lightBlue, pink }