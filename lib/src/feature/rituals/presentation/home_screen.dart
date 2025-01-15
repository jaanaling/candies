import 'package:candies/routes/route_value.dart';
import 'package:candies/src/core/utils/app_icon.dart';
import 'package:candies/src/core/utils/icon_provider.dart';
import 'package:candies/src/feature/rituals/bloc/app_bloc.dart';
import 'package:candies/src/feature/rituals/model/recipe.dart';
import 'package:candies/ui_kit/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          icon: IconProvider.bomb.buildImageUrl(),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isActive ? Colors.red : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            AppIcon(
              asset: icon,
              width: 78,
              height: 72,
            ),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget buildTop(List<Recipe> allRecipes, int count) {
    return Row(
      children: [
        IconButton(
          icon: AppIcon(
            asset: IconProvider.filtr.buildImageUrl(),
            width: 21,
            height: 21,
          ),
          onPressed: () {
            setState(() {
              showCompletedOnly = !showCompletedOnly;
              filteredRecipes(allRecipes);
            });
          },
        ),
        SizedBox(
          width: 300,
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search...',
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
                filteredRecipes(allRecipes);
              });
            },
          ),
        ),
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
            width: 37,
            height: 37,
          ),
          if (count > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
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
    return Material(
      color: Colors.transparent,
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state is! AppLoaded) return const SizedBox();
  
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 140),
                child: Column(
                  children: [
                    buildCategoryButtons(),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredRecipes(state.recipes).length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final recipe = filteredRecipes(state.recipes)[index];
                
                          if (recipe.isLocked) {
                            return AppIcon(
                              asset: IconProvider.lock.buildImageUrl(),
                              width: 29,
                              height: 32,
                            );
                          }
                
                          return ListTile(
                            title: Text(recipe.title),
                            subtitle: Row(
                              children: [
                                for (int i = 0; i < 5; i++)
                                  AppIcon(
                                    asset: IconProvider.bombres.buildImageUrl(),
                                    color: i <
                                     recipe.difficulty
                                        ? null
                                        : Colors.grey,
                                    width: 21,
                                    height: 21,
                                  ),
                                const SizedBox(width: 10),
                                if (recipe.isCompleted)
                                  const Text('done')
                                else
                                  const Text('in progress'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: AppIcon(
                                asset: IconProvider.heart.buildImageUrl(),
                                color: recipe.isFavorite ? null : Colors.grey,
                                width: 33,
                                height: 30,
                              ),
                              onPressed: () {
                                toggleFavorite(recipe);
                              },
                            ),
                            onTap: () => openRecipe(recipe),
                          );
                        },
                      ),
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
      ),
    );
  }
}
