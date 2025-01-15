import 'package:candies/src/feature/rituals/repository/shopping_repository.dart';
import 'package:candies/src/feature/rituals/repository/user_repository.dart';
import 'package:get_it/get_it.dart';


final locator = GetIt.instance;

void setupDependencyInjection() {
  locator.registerLazySingleton(() => ShoppingListRepository());
  locator.registerLazySingleton(() => RecipeRepository());

}
