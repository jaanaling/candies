import 'package:candies/src/core/utils/app_icon.dart';
import 'package:candies/src/core/utils/icon_provider.dart';
import 'package:candies/src/feature/rituals/bloc/app_bloc.dart';
import 'package:candies/src/feature/rituals/model/shopping_list.dart';
import 'package:candies/ui_kit/app_bar.dart';
import 'package:candies/ui_kit/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  void removeItem(ShoppingList item, BuildContext context) {
    context.read<AppBloc>().add(RemoveShoppingItemEvent(item));
  }

  void removeAll(BuildContext context) {
    context.read<AppBloc>().add(RemoveAllShoppingItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state is! AppLoaded) return const SizedBox();

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.shoppingList.length,
                      separatorBuilder: (_, __) => const Gap(16),
                      itemBuilder: (context, index) {
                        final item = state.shoppingList[index];
                        return Row(
                          children: [
                            AppButton(
                              color: ButtonColors.pink,
                              widget: Row(
                                children: [
                                  Text(item.name),
                                  Text(item.quantity),
                                ],
                              ),
                            ),
                            AppButton(
                              color: ButtonColors.blue,
                              widget: AppIcon(
                                asset: IconProvider.shop.buildImageUrl(),
                                width: 50,
                                height: 43,
                              ),
                              onPressed: () => removeItem(item, context),
                            ),
                            AppButton(
                              color: ButtonColors.red,
                              widget: AppIcon(
                                asset: IconProvider.remove.buildImageUrl(),
                                width: 33,
                                height: 30,
                              ),
                              onPressed: () => removeItem(item, context),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AppButton(
                          color: ButtonColors.red,
                          onPressed: () => removeAll(context),
                          widget: const Text('remove all'),
                        ),
                        AppButton(
                          color: ButtonColors.green,
                          onPressed: () => removeAll(context),
                          widget: const Text('buy all'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const AppBarWidget(
                widgets: Text('Shopping List'),
                hasBackButton: true,
              ),
            ],
          );
        },
      ),
    );
  }
}
