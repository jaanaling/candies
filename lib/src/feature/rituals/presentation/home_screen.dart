import 'dart:io';

import 'package:candies/routes/route_value.dart';
import 'package:candies/src/core/utils/app_icon.dart';
import 'package:candies/src/core/utils/cupertino_snack_bar.dart';
import 'package:candies/src/core/utils/icon_provider.dart';
import 'package:candies/src/core/utils/size_utils.dart';
import 'package:candies/src/feature/rituals/bloc/app_bloc.dart';
import 'package:candies/src/feature/rituals/model/recipe.dart';
import 'package:candies/ui_kit/app_bar.dart';
import 'package:candies/ui_kit/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

enum RecipeScreenMode {
  common,
  bombs,
  favorites,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RecipeScreenMode currentMode = RecipeScreenMode.common;
  String searchQuery = '';
  bool showCompletedOnly = false;
  int showDiffulty = 0;

  void showFilterPopup() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Select a filter'),
        message: const Text('Filter by difficulty or pass rate'),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Filter by complexity'),
            onPressed: () {
              // Закрываем ActionSheet и открываем Picker
              context.pop();
              showDifficultyPicker();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Passage filter'),
            onPressed: () {
              setState(() {
                showCompletedOnly = !showCompletedOnly;
              });
              context.pop();
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancellation'),
          isDefaultAction: true,
          onPressed: () {
            context.pop();
          },
        ),
      ),
    );
  }

  // Метод, который показывает выбор сложности
  void showDifficultyPicker() {
    // Сохраняем текущее значение сложности,
    // чтобы при прокрутке Picker не менять
    // состояние экрана до подтверждения
    int tempDifficulty = showDiffulty;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 250,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: tempDifficulty),
                  itemExtent: 32,
                  onSelectedItemChanged: (int index) {
                    tempDifficulty = index;
                  },
                  children: List<Widget>.generate(6, (int index) {
                    // Можно ограничить, например, от 0 до 5, где 0 = без фильтра
                    return Center(
                      child: Text(
                        index == 0 ? "Cancellation" : 'Complexity $index',
                      ),
                    );
                  }),
                ),
              ),
              CupertinoButton(
                child: const Text('Apply'),
                onPressed: () {
                  setState(() {
                    showDiffulty = tempDifficulty;
                  });
                  context.pop(); // Закрываем Picker
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<Recipe> filteredRecipes(List<Recipe> allRecipes) {
    List<Recipe> byCategory;
    switch (currentMode) {
      case RecipeScreenMode.common:
        byCategory = allRecipes
            .where((r) => r.category == RecipeCategory.normal)
            .toList();
      case RecipeScreenMode.bombs:
        byCategory =
            allRecipes.where((r) => r.category == RecipeCategory.bomb).toList();
      case RecipeScreenMode.favorites:
        byCategory = allRecipes.where((r) => r.isFavorite).toList();
    }

    if (showCompletedOnly) {
      byCategory = byCategory.where((r) => r.isCompleted).toList();
    }

    if (showDiffulty > 0) {
      byCategory =
          byCategory.where((r) => r.difficulty == showDiffulty).toList();
    }

    if (searchQuery.isNotEmpty) {
      byCategory = byCategory
          .where(
            (r) => r.title.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    return byCategory;
  }

  void toggleFavorite(Recipe recipe) {
    context.read<AppBloc>().add(
          UpdateRecipeEvent(recipe.copyWith(isFavorite: !recipe.isFavorite)),
        );
  }

  void openRecipe(Recipe recipe) {
    context.push(
      '${RouteValue.home.path}/${RouteValue.recipe.path}',
      extra: recipe,
    );
  }

  void openShoppingList() {
    context.push('${RouteValue.home.path}/${RouteValue.shop.path}');
  }

  Widget buildCategoryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCategoryButton(
          icon: IconProvider.common.buildImageUrl(),
          label: 'Common recipes',
          isActive: currentMode == RecipeScreenMode.common,
          onTap: () {
            setState(() {
              currentMode = RecipeScreenMode.common;
            });
          },
        ),
        _buildCategoryButton(
          icon: IconProvider.bombres.buildImageUrl(),
          label: 'Sweet bombs',
          isActive: currentMode == RecipeScreenMode.bombs,
          onTap: () {
            setState(() {
              currentMode = RecipeScreenMode.bombs;
            });
          },
        ),
        _buildCategoryButton(
          icon: IconProvider.heart.buildImageUrl(),
          label: 'Favorite recipes',
          isActive: currentMode == RecipeScreenMode.favorites,
          onTap: () {
            setState(() {
              currentMode = RecipeScreenMode.favorites;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCategoryButton({
    required String icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return AppButton(
      color: isActive ? ButtonColors.purple : ButtonColors.darkPurple,
      radius: 12,
      height: 85,
      width: getWidth(context, baseSize: 110),
      onPressed: onTap,
      widget: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          AppIcon(
            asset: icon,
            width: 78,
            height: 72,
          ),
          Text(label),
        ],
      ),
    );
  }

  Widget buildTop(List<Recipe> allRecipes, int count) {
    return Row(
      children: [
        IconButton(
          icon: AppIcon(
            asset: IconProvider.filtr.buildImageUrl(),
            width: 42,
            height: 37,
          ),
          onPressed: () {
            showFilterPopup();
          },
        ),
        AppButton(
          color: ButtonColors.deepPurple,
          width: getWidth(context, percent: 1) - 141,
          bottomPadding: 2,
          radius: 9,
          height: 55,
          widget: Material(
            color: Colors.transparent,
            child: TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
              style: const TextStyle(fontSize: 16, color: Colors.white),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  filteredRecipes(allRecipes);
                });
              },
            ),
          ),
        ),
        Gap(11),
        buildCartIcon(count),
      ],
    );
  }

  Widget buildCartIcon(int count) {
    return GestureDetector(
      onTap: openShoppingList,
      child: Stack(
        children: [
          AppIcon(
            asset: IconProvider.shop.buildImageUrl(),
            width: 42,
            height: 40,
          ),
          if (count > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is! AppLoaded) return const SizedBox();

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 140),
              child: Column(
                children: [
                  buildCategoryButtons(),
                  if (currentMode != RecipeScreenMode.bombs)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredRecipes(state.recipes).length,
                      separatorBuilder: (context, index) => Gap(17),
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipes(state.recipes)[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          child: AppButton(
                            color: ButtonColors.purple,
                            width: getWidth(
                                  context,
                                  percent: 1,
                                ) -
                                22,
                            height: 124,
                            widget: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
                              child: Row(
                                children: [
                                  AppIcon(
                                    asset: recipe.image,
                                    width: 101,
                                    height: 101,
                                    fit: BoxFit.cover,
                                  ),
                                  Gap(6),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(recipe.title),
                                            IconButton(
                                              alignment: Alignment.centerRight,
                                              iconSize: 33,
                                              padding: EdgeInsets.zero,
                                              icon: AppIcon(
                                                fit: BoxFit.cover,
                                                asset: IconProvider.heart
                                                    .buildImageUrl(),
                                                color: recipe.isFavorite
                                                    ? null
                                                    : Colors.black
                                                        .withOpacity(0.5),
                                                blendMode: BlendMode.srcATop,
                                                width: 33,
                                                height: 30,
                                              ),
                                              onPressed: () {
                                                toggleFavorite(recipe);
                                              },
                                            ),
                                          ],
                                        ),
                                        AppButton(
                                          color: ButtonColors.deepPurple,
                                          height: 31,
                                          width: 121,
                                          radius: 6,
                                          bottomPadding: 1,
                                          widget: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              for (int i = 0; i < 5; i++)
                                                AppIcon(
                                                  asset: IconProvider.bombres
                                                      .buildImageUrl(),
                                                  color: i < recipe.difficulty
                                                      ? null
                                                      : Colors.black
                                                          .withOpacity(0.5),
                                                  blendMode: BlendMode.srcATop,
                                                  width: 21,
                                                  height: 21,
                                                ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              if (recipe.isCompleted)
                                                const Text('done')
                                              else
                                                const Text('in progress'),
                                              Gap(6),
                                              AppButton(
                                                  radius: 6,
                                                  topPadding: 0,
                                                  bottomPadding: 0,
                                                  color:
                                                      ButtonColors.deepPurple,
                                                  widget: recipe.isCompleted
                                                      ? Icon(
                                                          CupertinoIcons
                                                              .check_mark,
                                                          color: const Color(
                                                              0xFFF285E5))
                                                      : SizedBox(),
                                                  width: 32,
                                                  height: 32)
                                            ])
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () => openRecipe(recipe),
                          ),
                        );
                      },
                    )
                  else
                    Wrap(
                      children: [
                        for (final recipe in filteredRecipes(state.recipes))
                          SizedBox(
                            width: getWidth(context, percent: 0.3),
                            height: getWidth(context, percent: 0.3),
                            child: GestureDetector(
                              onTap: () => recipe.isLocked
                                  ? showCupertinoSnackBar(context,
                                      'This recipe is locked. Need complite previous recipes to unlock this one. You need to complete ${recipe.requiredCountToUnlock - state.recipes.where((r) => r.isCompleted).length}')
                                  : openRecipe(recipe),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: recipe.isLocked
                                        ? AssetImage(
                                            IconProvider.bomb.buildImageUrl(),
                                          )
                                        : FileImage(
                                            File(recipe.image),
                                          ),
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    if (recipe.isLocked)
                                      Image.asset(
                                        IconProvider.lock.buildImageUrl(),
                                      )
                                    else
                                      Text(
                                        recipe.isCompleted
                                            ? 'done'
                                            : 'in progress',
                                      ),
                                    Text(recipe.title),
                                    if (recipe.isLocked == false)
                                      Row(
                                        children: [
                                          for (int i = 0; i < 5; i++)
                                            AppIcon(
                                              asset: IconProvider.bombres
                                                  .buildImageUrl(),
                                              color: i < recipe.difficulty
                                                  ? null
                                                  : Colors.grey,
                                              width: 21,
                                              height: 21,
                                            ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
            AppBarWidget(
              widgets: buildTop(state.recipes, state.shoppingList.length),
            ),
          ],
        );
      },
    );
  }
}
