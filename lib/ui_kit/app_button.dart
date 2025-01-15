import 'package:flutter/cupertino.dart';

enum ButtonColors { blue, green }

class AppButton extends StatelessWidget {
  final ButtonColors color;
  final Widget child;
  final Color? overlayColor;
  final double radius;
  final bool needsWrap;
  const AppButton(
      {super.key, required this.color, required this.child, this.overlayColor, this.radius = 2.5, this.needsWrap = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          colors: color == ButtonColors.blue
              ? [
                  Color(0xFF070041),
                  Color(0xFF00EEFF),
                  Color(0xFF04003B),
                ]
              : [
                  Color(0xFF004100),
                  Color(0xFF0DFF00),
                  Color(0xFF003B0B),
                ],
          stops: [0, 0.55, 1],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(needsWrap?4:0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: RadialGradient(
              radius: radius,
              focal: Alignment.topCenter,
              colors: color == ButtonColors.blue
                  ? [
                      Color(0xFF00EEFF),
                      Color(0xFF070041),
                    ]
                  : [
                      Color(0xFF5dfa7d),
                      Color(0xFF04260f),
                    ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical:needsWrap? 2:0, horizontal:needsWrap? 4:0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: overlayColor ??
                      (color == ButtonColors.blue
                          ? Color(0x4029CEDA)
                          : Color(0x4067DA29))),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
