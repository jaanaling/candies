import 'package:candies/src/core/utils/app_icon.dart';
import 'package:candies/src/core/utils/icon_provider.dart';
import 'package:candies/src/core/utils/size_utils.dart';
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
    return Row(
      children: [
        SizedBox(
          width: getWidth(context, percent: 1),
          height: 115.5 + MediaQuery.of(context).padding.top,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xFFFF48A0),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 42,
                top: MediaQuery.of(context).padding.top,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
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
        ),
      ],
    );
  }
}
