import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../data/models/favorite_model.dart';
import '../presentation/providers/favorites_provider.dart';
import '../data/models/doctor_model.dart';
import '../data/models/clinic_model.dart';
import '../domain/repositories/doctor_repository.dart';
import '../domain/repositories/clinic_repository.dart';
import '../core/di/injection_container.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final Map<String, dynamic> _itemsCache = {};
  bool _isLoading = false;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadFavoriteItems();
    }
  }

  Future<void> _loadFavoriteItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final favorites = context.read<FavoritesProvider>().favorites;
      final doctorRepository = getIt<DoctorRepository>();
      final clinicRepository = getIt<ClinicRepository>();

      for (var favorite in favorites) {
        if (!_itemsCache.containsKey(favorite.itemId)) {
          if (favorite.itemType == 'doctor') {
            final doctor = await doctorRepository.getDoctorById(favorite.itemId);
            _itemsCache[favorite.itemId] = doctor;
          } else if (favorite.itemType == 'clinic') {
            final clinic = await clinicRepository.getClinicById(favorite.itemId);
            _itemsCache[favorite.itemId] = clinic;
          }
        }
      }
    } catch (e) {
      if (mounted) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao carregar favoritos')),
          );
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildFavoriteItem(FavoriteModel favorite) {
    final item = _itemsCache[favorite.itemId];
    
    // Se ainda não carregou os detalhes, mostra um placeholder
    if (item == null) {
      return ListTile(
        leading: CircleAvatar(
          child: Icon(
            favorite.itemType == 'doctor' ? Icons.person : Icons.local_hospital,
          ),
        ),
        title: Text(favorite.itemType == 'doctor' ? 'Médico' : 'Clínica'),
        subtitle: Text('ID: ${favorite.itemId}'),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () async {
            await context.read<FavoritesProvider>().removeFavorite(favorite.id);
            setState(() {
              _itemsCache.remove(favorite.itemId);
            });
          },
        ),
      );
    }

    if (favorite.itemType == 'doctor') {
      final doctor = item as DoctorModel;
      return ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text('Dr. ${doctor.name}'),
        subtitle: Text(doctor.specialty),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () async {
            await context.read<FavoritesProvider>().removeFavorite(favorite.id);
            setState(() {
              _itemsCache.remove(favorite.itemId);
            });
          },
        ),
        onTap: () {
          // Navegar para a tela de detalhes do médico
          context.push('/doctor-profile', extra: {
            'doctor': {
              'id': doctor.id,
              'name': doctor.name,
              'specialty': doctor.specialty,
              'rating': doctor.rating,
              'experience': doctor.experience,
              'price': doctor.price,
              'image': doctor.image,
            },
            'clinicName': 'Clínica Favorita', // Você pode ajustar isso se tiver a info da clínica
          });
        },
      );
    } else if (favorite.itemType == 'clinic') {
      final clinic = item as ClinicModel;
      return ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.local_hospital),
        ),
        title: Text(clinic.name),
        subtitle: Text(clinic.address),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () async {
            await context.read<FavoritesProvider>().removeFavorite(favorite.id);
            setState(() {
              _itemsCache.remove(favorite.itemId);
            });
          },
        ),
        onTap: () {
          // Navegar para a lista de médicos da clínica
          context.push('/doctors/${Uri.encodeComponent(clinic.name)}');
        },
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final favorites = favoritesProvider.favorites;
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Você ainda não tem favoritos',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // Navegar para a tela de busca
                    },
                    child: const Text('Explorar médicos e clínicas'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadFavoriteItems,
            child: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return _buildFavoriteItem(favorite);
              },
            ),
          );
        },
      ),
    );
  }
}
