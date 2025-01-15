import 'package:candies/src/feature/rituals/model/recipe.dart';

import '../../../core/utils/json_loader.dart';

/// Репозиторий для советов.
class RecipeRepository {
  final String key = 'recipe';

  Future<List<Recipe>> load() {
    return JsonLoader.loadData<Recipe>(
      key,
      'assets/json/$key.json',
      (json) => Recipe.fromMap(json),
    );
  }

  Future<void> update(Recipe updated) async {
    return JsonLoader.modifyDataList<Recipe>(
      key,
      updated,
      () async => await load(),
      (item) => item.toMap(),
      (itemList) async {
        itemList.first = updated;
      },
    );
  }

  Future<void> save(Recipe item) {
    return JsonLoader.saveData<Recipe>(
      key,
      item,
      () async => await load(),
      (item) => item.toMap(),
    );
  }

  Future<void> remove(Recipe item) {
    return JsonLoader.removeData<Recipe>(
      key,
      item,
      () async => await load(),
      (item) => item.toMap(),
    );
  }
}
