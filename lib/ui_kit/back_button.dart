import 'package:candies/src/core/utils/app_icon.dart';
import 'package:candies/src/core/utils/icon_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';


class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const AppBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ??
          () {
            context.pop();
          },
      child: DecoratedBox(
        decoration:
            ShapeDecoration(shape: OvalBorder(), color: Color(0xFF8F0404)),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Center(
            child: SizedBox(
                width: 20,
                height: 17,
                child: AppIcon(asset: IconProvider.arrow.buildImageUrl())),
          ),
        ),
      ),
    );
  }
}
