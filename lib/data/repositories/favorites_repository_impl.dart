import '../../core/services/favorites_service.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../models/favorite_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesService _favoritesService;

  FavoritesRepositoryImpl(this._favoritesService);

  @override
  Future<List<FavoriteModel>> getFavorites() async {
    return await _favoritesService.getFavorites();
  }

  @override
  Future<void> addFavorite(FavoriteModel favorite) async {
    await _favoritesService.addFavorite(favorite);
  }

  @override
  Future<void> removeFavorite(String id) async {
    await _favoritesService.removeFavorite(id);
  }

  @override
  Future<bool> isFavorite(String itemId, String itemType) async {
    return await _favoritesService.isFavorite(itemId, itemType);
  }
}
