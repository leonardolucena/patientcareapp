import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/favorite_model.dart';

class FavoritesService {
  static const String _favoritesKey = 'user_favorites';
  final SharedPreferences _prefs;

  FavoritesService(this._prefs);

  Future<List<FavoriteModel>> getFavorites() async {
    final String? favoritesJson = _prefs.getString(_favoritesKey);
    print('FavoritesService.getFavorites: favoritesJson = $favoritesJson');
    if (favoritesJson == null) return [];

    final List<dynamic> decodedList = json.decode(favoritesJson);
    final favorites = decodedList
        .map((item) => FavoriteModel.fromJson(item as Map<String, dynamic>))
        .toList();
    print('FavoritesService.getFavorites: ${favorites.length} favoritos encontrados');
    return favorites;
  }

  Future<void> addFavorite(FavoriteModel favorite) async {
    print('FavoritesService.addFavorite: Adicionando ${favorite.itemId}');
    final favorites = await getFavorites();
    if (!favorites.contains(favorite)) {
      favorites.add(favorite);
      await _saveFavorites(favorites);
      print('FavoritesService.addFavorite: Favorito salvo! Total: ${favorites.length}');
    } else {
      print('FavoritesService.addFavorite: Favorito já existe');
    }
  }

  Future<void> removeFavorite(String id) async {
    final favorites = await getFavorites();
    favorites.removeWhere((favorite) => favorite.id == id);
    await _saveFavorites(favorites);
  }

  Future<bool> isFavorite(String itemId, String itemType) async {
    final favorites = await getFavorites();
    return favorites.any(
      (favorite) => favorite.itemId == itemId && favorite.itemType == itemType,
    );
  }

  Future<void> _saveFavorites(List<FavoriteModel> favorites) async {
    final String encodedList = json.encode(
      favorites.map((favorite) => favorite.toJson()).toList(),
    );
    print('FavoritesService._saveFavorites: Salvando ${favorites.length} favoritos');
    print('FavoritesService._saveFavorites: JSON = $encodedList');
    await _prefs.setString(_favoritesKey, encodedList);
  }
}
