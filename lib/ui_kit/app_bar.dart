import 'package:candies/src/core/utils/app_icon.dart';
import 'package:candies/src/core/utils/icon_provider.dart';
import 'package:candies/src/core/utils/size_utils.dart';
import 'package:candies/ui_kit/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarWidget extends StatelessWidget {
  final Widget widgets;
  final bool hasBackButton;

  const AppBarWidget({
    super.key,
    required this.widgets,
    this.hasBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      color: ButtonColors.pink,
      radius: 0,
      widget: SizedBox(
        width: getWidth(context, percent: 1),
        height: getHeight(context, percent: 0.14) ,
        child: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: MediaQuery.of(context).padding.top,
          ),
          child: Row(
            children: [
              if (hasBackButton)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.pop();
                      },
                      child: AppIcon(
                        asset: IconProvider.arrow.buildImageUrl(),
                        width: 50,
                        height: 43,
                      ),
                    ),
                  ),
                ),
              widgets,
            ],
          ),
        ),
      ),
    );
  }
}
