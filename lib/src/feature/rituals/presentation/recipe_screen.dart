import 'dart:async';

import 'package:candies/src/core/utils/app_icon.dart';
import 'package:candies/src/core/utils/cupertino_snack_bar.dart';
import 'package:candies/src/core/utils/icon_provider.dart';
import 'package:candies/src/core/utils/size_utils.dart';
import 'package:candies/src/feature/rituals/bloc/app_bloc.dart';
import 'package:candies/src/feature/rituals/model/recipe.dart';
import 'package:candies/src/feature/rituals/model/shopping_list.dart';
import 'package:candies/ui_kit/app_bar.dart';
import 'package:candies/ui_kit/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeScreen({super.key, required this.recipe});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int currentStep = 0;
  Timer? _timer;
  int _timeLeft = 0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _setupCurrentStepTimer();
    isFavorite = widget.recipe.isFavorite;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setupCurrentStepTimer() {
    _timer?.cancel();

    if (currentStep < widget.recipe.steps.length &&
        widget.recipe.steps[currentStep].timer != null) {
      _timeLeft = widget.recipe.steps[currentStep].timer!;
      if (_timeLeft > 0) {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            if (_timeLeft > 0) {
              _timeLeft--;
            } else {
              timer.cancel();
            }
          });
        });
      }
    }
  }

  void _goToNextStep() {
    if (currentStep < widget.recipe.steps.length - 1) {
      setState(() {
        currentStep++;
      });
      _setupCurrentStepTimer();
    } else {
      context.read<AppBloc>().add(
            UpdateRecipeEvent(
              widget.recipe.copyWith(isCompleted: true),
            ),
          );
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('CONGRATULATIONS!'),
          content: const Text('You have completed this recipe!'),
          actions: [
            TextButton(
              onPressed: () => context
                ..pop()
                ..pop(),
              child: const Text('back'),
            ),
          ],
        ),
      );
    }
  }

  void _shareRecipe() {
    Share.share('Check out this recipe: ${widget.recipe.title}');
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.recipe.steps[currentStep];

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: widget.recipe.ingredients.length,
      
                separatorBuilder: (context, index) => const Gap(16),
                itemBuilder: (context, index) => Row(
                  children: [
                    AppButton(
                      color: ButtonColors.pink,
                      widget: Row(
                        children: [
                          Text(widget.recipe.ingredients[index].name),
                          Text(widget.recipe.ingredients[index].quantity),
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
                      onPressed: () {
                        context.read<AppBloc>().add(
                              AddShoppingItemEvent(
                                ShoppingList(
                                  id: const Uuid().v4(),
                                  name: widget.recipe.ingredients[index].name,
                                  quantity:
                                      widget.recipe.ingredients[index].quantity,
                                ),
                              ),
                            );
                        showCupertinoSnackBar(context,
                            '${widget.recipe.ingredients[index].name}: Added to shopping list');
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: getWidth(context, percent: 0.7),
              height: getHeight(context, percent: 0.4),
      
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: Color(0x7C2A004B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Step ${currentStep + 1} of ${widget.recipe.steps.length}',
                    ),
                    const SizedBox(height: 8),
                    Text(step.description),
                    const SizedBox(height: 8),
                    if (step.timer != null && step.timer! > 0)
                      Row(
                        children: [
                          AppIcon(
                            asset: IconProvider.time.buildImageUrl(),
                            width: 73,
                            height: 74,
                          ),
                          Text('$_timeLeft'),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: AppIcon(
                    asset: IconProvider.arrow.buildImageUrl(),
                    width: 50,
                    height: 43,
                  ),
                  onPressed: () {
                    if (currentStep > 0) {
                      setState(() {
                        currentStep--;
                      });
                      _setupCurrentStepTimer();
                    }
                  },
                ),
                IconButton(
                  icon: Transform.rotate(
                    angle: 3.14,
                    child: AppIcon(
                      asset: IconProvider.arrow.buildImageUrl(),
                      width: 50,
                      height: 43,
                    ),
                  ),
                  onPressed: _goToNextStep,
                ),
              ],
            ),
          ],
        ),
        AppBarWidget(
          widgets: Row(
            children: [
              Text(widget.recipe.title),
              IconButton(
                icon: AppIcon(
                  asset: IconProvider.heart.buildImageUrl(),
                  color: isFavorite ? null : Colors.grey,
                  width: 33,
                  height: 30,
                ),
                onPressed: () {
                  context.read<AppBloc>().add(
                        UpdateRecipeEvent(
                          widget.recipe.copyWith(isFavorite: !isFavorite),
                        ),
                      );
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
              ),
              IconButton(
                icon: AppIcon(
                  asset: IconProvider.share.buildImageUrl(),
                  width: 32,
                  height: 33,
                ),
                onPressed: _shareRecipe,
              ),
            ],
          ),
          hasBackButton: true,
        ),
      ],
    );
  }
}
