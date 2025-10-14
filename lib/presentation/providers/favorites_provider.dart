import 'package:flutter/foundation.dart';
import '../../data/models/favorite_model.dart';
import '../../domain/repositories/favorites_repository.dart';

class FavoritesProvider with ChangeNotifier {
  final FavoritesRepository _repository;
  List<FavoriteModel> _favorites = [];
  bool _isLoading = false;

  late final Future<void> _initializationFuture;

  FavoritesProvider(this._repository) {
    _initializationFuture = _loadFavorites();
  }

  Future<void> waitForInitialization() => _initializationFuture;

  List<FavoriteModel> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;

  Future<void> _loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('FavoritesProvider: Carregando favoritos do armazenamento...');
      _favorites = await _repository.getFavorites();
      debugPrint('FavoritesProvider: ${_favorites.length} favoritos carregados');
      for (var fav in _favorites) {
        debugPrint('  - ${fav.itemId} (${fav.itemType})');
      }
    } catch (e) {
      debugPrint('Erro ao carregar favoritos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorite(FavoriteModel favorite) async {
    try {
      debugPrint('FavoritesProvider: Adicionando favorito ${favorite.itemId}');
      await _repository.addFavorite(favorite);
      _favorites.add(favorite);
      debugPrint('FavoritesProvider: Total de favoritos agora: ${_favorites.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao adicionar favorito: $e');
      rethrow;
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await _repository.removeFavorite(id);
      _favorites.removeWhere((favorite) => favorite.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao remover favorito: $e');
      rethrow;
    }
  }

  Future<bool> isFavorite(String itemId, String itemType) async {
    try {
      return await _repository.isFavorite(itemId, itemType);
    } catch (e) {
      debugPrint('Erro ao verificar favorito: $e');
      return false;
    }
  }

  void refresh() {
    _loadFavorites();
  }
}
