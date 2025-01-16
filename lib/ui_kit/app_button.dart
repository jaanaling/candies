import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inner_glow/inner_glow.dart';

class AppButton extends StatelessWidget {
  final ButtonColors color;
  final Widget widget;
  final VoidCallback? onPressed;
  final double radius;
  final bool isRound;
  final double width;
  final double height;
  final double topPadding;
  final double bottomPadding;
  final GlobalKey? globalKey;

  const AppButton({
    super.key,
    required this.color,
    required this.widget,
    this.onPressed,
    this.radius = 14,
    required this.width,
    this.isRound = false,
    this.globalKey,
    this.topPadding = 4,
    this.bottomPadding = 4,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyleConfig styleConfig = _getButtonStyleConfig(color);

    return Material(
      key: globalKey,
      textStyle: TextStyle(
      fontFamily: 'Poetsen',
      fontWeight: FontWeight.w700,
      fontSize: 20,
      color: Colors.white,
      shadows: [
        Shadow(
          offset: Offset(2.0, 2.0), // Смещение тени
          color: Color(0x80000000), // Цвет тени с прозрачностью
          blurRadius: 4,
        ),
      ],
    ),
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      elevation: 5,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        splashColor: styleConfig.splashColor,
        child: Ink(
          width: width,
          decoration: ShapeDecoration(
            gradient: styleConfig.outerGradient,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 2,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: styleConfig.borderColor,
              ),
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: styleConfig.needsTop ? topPadding : 0,
              bottom: bottomPadding,
            ),
            child: InnerGlow(
              width: width,
              height: height,
              glowRadius: radius,
              thickness: 10,
              glowBlur: 5,
              strokeLinearGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: color == ButtonColors.deepPurple
                    ? [Colors.black.withOpacity(0.25), Colors.transparent]
                    : [Color(0x30FFFFFF), Color(0x30FFFFFF)],
              ),
              baseDecoration: BoxDecoration(
                gradient: styleConfig.innerGradient,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Center(child: widget),
            ),
          ),
        ),
      ),
    );
  }

  ButtonStyleConfig _getButtonStyleConfig(ButtonColors color) {
    switch (color) {
      case ButtonColors.red:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFFFBBBB),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFBBBB), Color(0xFF8a0100)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF5E5E), Color(0xFFB80000)],
          ),
        );
      case ButtonColors.purple:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFFFC8F1),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFC8F1), Color(0xFF8d00d8)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF98FE2), Color(0xFFAC28F5)],
          ),
        );
      case ButtonColors.green:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFBBFFC7),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFBBFFC7), Color(0xFF03700e)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5EFF5E), Color(0xFF2F8900)],
          ),
        );
      case ButtonColors.blue:
        return const ButtonStyleConfig(
          splashColor: Color(0xFF8DF7FB),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8DF7FB), Color(0xFF056eff)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF15F2FF), Color(0xFF10A9FF)],
          ),
        );
      case ButtonColors.deepPurple:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFEC8AFF),
          borderColor: Colors.transparent,
          needsTop: false,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEC8AFF), Color(0xFFEC8AFF)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF680199), Color(0xFF680199)],
          ),
        );
      case ButtonColors.darkPurple:
        return const ButtonStyleConfig(
          splashColor: Color(0xFFBB7FC9),
          borderColor: Colors.transparent,
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA67FE9), Color(0xFF3d005c)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6E00A1), Color(0xFF580089)],
          ),
        );
      default:
        // Для остальных вариантов
        return const ButtonStyleConfig(
          splashColor: Color(0xFFf86dac),
          borderColor: Color(0xFF590027),
          outerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFf86dac), Color(0xFFad086c)],
          ),
          innerGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8187B), Color(0xFFC90A7F)],
          ),
        );
    }
  }
}

class ButtonStyleConfig {
  final Color splashColor;
  final Color borderColor;
  final LinearGradient outerGradient;
  final LinearGradient innerGradient;
  final bool needsTop;

  const ButtonStyleConfig(
      {required this.splashColor,
      required this.borderColor,
      required this.outerGradient,
      required this.innerGradient,
      this.needsTop = true});
}

enum ButtonColors { purple, darkPurple, deepPurple, red, green, blue }
