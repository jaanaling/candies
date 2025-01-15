import 'package:candies/src/core/dependency_injection.dart';
import 'package:candies/src/feature/rituals/model/recipe.dart';
import 'package:candies/src/feature/rituals/model/shopping_list.dart';
import 'package:candies/src/feature/rituals/repository/shopping_repository.dart';
import 'package:candies/src/feature/rituals/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final RecipeRepository recipeRepository = locator<RecipeRepository>();
  final ShoppingListRepository shoppingRepository = locator<ShoppingListRepository>();

  AppBloc() : super(AppLoading()) {
    on<LoadDataEvent>(_onLoadData);
    on<UpdateRecipeEvent>(_onUpdateRecipe);
    on<AddShoppingItemEvent>(_onAddShoppingItem);
    on<RemoveShoppingItemEvent>(_onRemoveShoppingItem);
    on<RemoveAllShoppingItemsEvent>(_removeAllShoppingItems);
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<AppState> emit,
  ) async {
    emit(AppLoading());
    try {
      final loadedRecipes = await recipeRepository.load();
      final loadedShoppingList = await shoppingRepository.load();
      emit(AppLoaded(
        recipes: loadedRecipes,
        shoppingList: loadedShoppingList,
      ));
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onUpdateRecipe(
    UpdateRecipeEvent event,
    Emitter<AppState> emit,
  ) async {
    if (state is! AppLoaded) return;

    try {
      await recipeRepository.update(event.recipe);
      final updatedRecipes = await recipeRepository.load();
      final currentShoppingList = (state as AppLoaded).shoppingList;
      emit(AppLoaded(
        recipes: updatedRecipes,
        shoppingList: currentShoppingList,
      ));
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onAddShoppingItem(
    AddShoppingItemEvent event,
    Emitter<AppState> emit,
  ) async {
    if (state is! AppLoaded) return;

    emit(AppLoading());
    try {
      await shoppingRepository.save(event.item);
      final updatedList = await shoppingRepository.load();
      final currentRecipes = (state as AppLoaded).recipes;
      emit(AppLoaded(
        recipes: currentRecipes,
        shoppingList: updatedList,
      ));
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onRemoveShoppingItem(
    RemoveShoppingItemEvent event,
    Emitter<AppState> emit,
  ) async {
    if (state is! AppLoaded) return;

    emit(AppLoading());
    try {
      await shoppingRepository.remove(event.item);
      final updatedList = await shoppingRepository.load();
      final currentRecipes = (state as AppLoaded).recipes;
      emit(AppLoaded(
        recipes: currentRecipes,
        shoppingList: updatedList,
      ));
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _removeAllShoppingItems(
    RemoveAllShoppingItemsEvent event,
    Emitter<AppState> emit,
  ) async {
    if (state is! AppLoaded) return;

    emit(AppLoading());
    try {
      for (var item in (state as AppLoaded).shoppingList) {
        await shoppingRepository.remove(item);
      }
      final updatedList = await shoppingRepository.load();
      final currentRecipes = (state as AppLoaded).recipes;
      emit(AppLoaded(
        recipes: currentRecipes,
        shoppingList: updatedList,
      ));
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }
}