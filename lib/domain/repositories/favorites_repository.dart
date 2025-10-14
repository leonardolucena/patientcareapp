import '../../data/models/favorite_model.dart';

abstract class FavoritesRepository {
  Future<List<FavoriteModel>> getFavorites();
  Future<void> addFavorite(FavoriteModel favorite);
  Future<void> removeFavorite(String id);
  Future<bool> isFavorite(String itemId, String itemType);
}
