import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/favorite_model.dart';
import '../providers/favorites_provider.dart';

class FavoriteButton extends StatefulWidget {
  final String itemId;
  final String itemType;

  const FavoriteButton({
    Key? key,
    required this.itemId,
    required this.itemType,
  }) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final favoritesProvider = context.read<FavoritesProvider>();
    final isFavorite = await favoritesProvider.isFavorite(
      widget.itemId,
      widget.itemType,
    );
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final favoritesProvider = context.read<FavoritesProvider>();
      
      if (_isFavorite) {
        // Encontrar o ID do favorito para remover
        final favorite = favoritesProvider.favorites.firstWhere(
          (f) => f.itemId == widget.itemId && f.itemType == widget.itemType,
        );
        await favoritesProvider.removeFavorite(favorite.id);
      } else {
        final newFavorite = FavoriteModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          itemId: widget.itemId,
          itemType: widget.itemType,
          createdAt: DateTime.now(),
        );
        debugPrint('Adicionando favorito: ${newFavorite.itemId} (${newFavorite.itemType})');
        await favoritesProvider.addFavorite(newFavorite);
        debugPrint('Favorito adicionado com sucesso!');
      }

      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      }
    } catch (e) {
      debugPrint('ERRO ao adicionar favorito: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite
                  ? 'Erro ao remover dos favoritos'
                  : 'Erro ao adicionar aos favoritos',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
      onPressed: _toggleFavorite,
    );
  }
}
