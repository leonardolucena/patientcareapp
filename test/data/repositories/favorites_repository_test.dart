import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:patientcareapp/core/services/favorites_service.dart';
import 'package:patientcareapp/data/models/favorite_model.dart';
import 'package:patientcareapp/data/repositories/favorites_repository_impl.dart';

@GenerateNiceMocks([MockSpec<FavoritesService>()])
import 'favorites_repository_test.mocks.dart';

void main() {
  late MockFavoritesService mockService;
  late FavoritesRepositoryImpl repository;

  setUp(() {
    mockService = MockFavoritesService();
    repository = FavoritesRepositoryImpl(mockService);
  });

  group('FavoritesRepository', () {
    final testFavorite = FavoriteModel(
      id: '1',
      itemId: 'doctor1',
      itemType: 'doctor',
      createdAt: DateTime.now(),
    );

    test('getFavorites returns list of favorites', () async {
      when(mockService.getFavorites())
          .thenAnswer((_) async => [testFavorite]);

      final result = await repository.getFavorites();

      expect(result, [testFavorite]);
      verify(mockService.getFavorites()).called(1);
    });

    test('addFavorite calls service', () async {
      when(mockService.addFavorite(testFavorite))
          .thenAnswer((_) async {});

      await repository.addFavorite(testFavorite);

      verify(mockService.addFavorite(testFavorite)).called(1);
    });

    test('removeFavorite calls service', () async {
      when(mockService.removeFavorite('1'))
          .thenAnswer((_) async {});

      await repository.removeFavorite('1');

      verify(mockService.removeFavorite('1')).called(1);
    });

    test('isFavorite returns correct value', () async {
      when(mockService.isFavorite('doctor1', 'doctor'))
          .thenAnswer((_) async => true);

      final result = await repository.isFavorite('doctor1', 'doctor');

      expect(result, true);
      verify(mockService.isFavorite('doctor1', 'doctor')).called(1);
    });
  });
}
