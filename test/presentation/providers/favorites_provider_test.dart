import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:patientcareapp/data/models/favorite_model.dart';
import 'package:patientcareapp/domain/repositories/favorites_repository.dart';
import 'package:patientcareapp/presentation/providers/favorites_provider.dart';

@GenerateNiceMocks([MockSpec<FavoritesRepository>()])
import 'favorites_provider_test.mocks.dart';

void main() {
  late MockFavoritesRepository mockRepository;
  late FavoritesProvider provider;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    provider = FavoritesProvider(mockRepository);
  });

  group('FavoritesProvider', () {
    final testFavorite = FavoriteModel(
      id: '1',
      itemId: 'doctor1',
      itemType: 'doctor',
      createdAt: DateTime.now(),
    );

    test('initial state is empty and not loading', () {
      expect(provider.favorites, isEmpty);
      expect(provider.isLoading, false);
    });

    test('getFavorites updates state correctly', () async {
      when(mockRepository.getFavorites())
          .thenAnswer((_) async => [testFavorite]);

      final testProvider = FavoritesProvider(mockRepository);
      await testProvider.waitForInitialization();

      expect(testProvider.favorites, [testFavorite]);
      expect(testProvider.isLoading, false);
      verify(mockRepository.getFavorites()).called(greaterThan(0));
    });

    test('addFavorite updates state correctly', () async {
      when(mockRepository.addFavorite(testFavorite))
          .thenAnswer((_) async {});
      when(mockRepository.getFavorites())
          .thenAnswer((_) async => []);

      await provider.addFavorite(testFavorite);

      expect(provider.favorites, [testFavorite]);
      verify(mockRepository.addFavorite(testFavorite)).called(1);
    });

    test('removeFavorite updates state correctly', () async {
      when(mockRepository.removeFavorite('1'))
          .thenAnswer((_) async {});
      when(mockRepository.getFavorites())
          .thenAnswer((_) async => [testFavorite]);

      final testProvider = FavoritesProvider(mockRepository);
      await testProvider.waitForInitialization();

      await testProvider.removeFavorite('1');

      expect(testProvider.favorites, isEmpty);
      verify(mockRepository.removeFavorite('1')).called(1);
    });

    test('isFavorite returns correct value', () async {
      when(mockRepository.isFavorite('doctor1', 'doctor'))
          .thenAnswer((_) async => true);

      final result = await provider.isFavorite('doctor1', 'doctor');

      expect(result, true);
      verify(mockRepository.isFavorite('doctor1', 'doctor')).called(1);
    });

    test('refresh reloads favorites', () async {
      when(mockRepository.getFavorites())
          .thenAnswer((_) async => [testFavorite]);

      final testProvider = FavoritesProvider(mockRepository);
      await testProvider.waitForInitialization();

      testProvider.refresh();
      await testProvider.waitForInitialization();

      expect(testProvider.favorites, [testFavorite]);
      verify(mockRepository.getFavorites()).called(greaterThan(1)); // Pelo menos duas chamadas: uma no construtor e outra no refresh
    });
  });
}
