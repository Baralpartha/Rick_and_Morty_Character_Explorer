import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/character_local_data_source.dart';
import '../../data/datasources/character_remote_data_source.dart';
import '../../data/models/character_edit_model.dart';
import '../../data/models/character_model.dart';
import '../../data/repositories/character_repository.dart';

final dioProvider = Provider((ref) => DioClient.create());
final connectivityProvider = Provider((ref) => Connectivity());
final localDataSourceProvider = Provider((ref) => CharacterLocalDataSource());
final remoteDataSourceProvider =
    Provider((ref) => CharacterRemoteDataSource(ref.read(dioProvider)));

final characterRepositoryProvider = Provider(
  (ref) => CharacterRepository(
    remote: ref.read(remoteDataSourceProvider),
    local: ref.read(localDataSourceProvider),
    connectivity: ref.read(connectivityProvider),
  ),
);

class CharacterListState {
  final List<CharacterModel> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isOffline;
  final bool hasMore;
  final String? error;
  final int nextPage;

  const CharacterListState({
    required this.items,
    required this.isLoading,
    required this.isLoadingMore,
    required this.isOffline,
    required this.hasMore,
    required this.nextPage,
    this.error,
  });

  factory CharacterListState.initial() => const CharacterListState(
        items: [],
        isLoading: true,
        isLoadingMore: false,
        isOffline: false,
        hasMore: true,
        nextPage: 1,
      );

  CharacterListState copyWith({
    List<CharacterModel>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isOffline,
    bool? hasMore,
    String? error,
    int? nextPage,
  }) {
    return CharacterListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isOffline: isOffline ?? this.isOffline,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class CharacterListNotifier extends StateNotifier<CharacterListState> {
  CharacterListNotifier(this.repository) : super(CharacterListState.initial()) {
    initialize();
  }

  final CharacterRepository repository;

  Future<void> initialize() async {
    try {
      final offline = await repository.isOffline();
      if (offline) {
        final cached = repository.getCachedMergedCharacters();
        state = state.copyWith(
          items: cached,
          isLoading: false,
          isOffline: true,
          hasMore: false,
          nextPage: repository.getNextPageFromCache() ?? 1,
        );
        return;
      }

      final items = await repository.fetchNextPage(page: 1);
      state = state.copyWith(
        items: items,
        isLoading: false,
        isOffline: false,
        hasMore: items.isNotEmpty,
        nextPage: 2,
      );
    } catch (e) {
      final cached = repository.getCachedMergedCharacters();
      state = state.copyWith(
        items: cached,
        isLoading: false,
        isOffline: cached.isNotEmpty,
        hasMore: false,
        error: cached.isEmpty ? e.toString() : null,
      );
    }
  }

  Future<void> fetchMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isOffline) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final newItems = await repository.fetchNextPage(page: state.nextPage);
      state = state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...newItems],
        hasMore: newItems.isNotEmpty,
        nextPage: state.nextPage + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  Future<void> refreshData() async {
    state = CharacterListState.initial();
    await initialize();
  }

  Future<void> toggleFavorite(int id) async {
    await repository.toggleFavorite(id);
    state = state.copyWith(items: [...repository.getCachedMergedCharacters()]);
  }

  Future<void> applyEdit(CharacterEditModel edit) async {
    await repository.saveEdit(edit);
    state = state.copyWith(items: [...repository.getCachedMergedCharacters()]);
  }

  Future<void> resetEdit(int id) async {
    await repository.resetEdit(id);
    state = state.copyWith(items: [...repository.getCachedMergedCharacters()]);
  }
}

final characterListProvider =
    StateNotifierProvider<CharacterListNotifier, CharacterListState>(
  (ref) => CharacterListNotifier(ref.read(characterRepositoryProvider)),
);

final favoriteIdsProvider = Provider<List<int>>(
  (ref) => ref.watch(characterRepositoryProvider).getFavoriteIds(),
);

final favoritesProvider = Provider<List<CharacterModel>>((ref) {
  ref.watch(characterListProvider);
  return ref.watch(characterRepositoryProvider).getFavoriteCharacters();
});

final characterByIdProvider = Provider.family<CharacterModel?, int>((ref, id) {
  final listState = ref.watch(characterListProvider);
  for (final item in listState.items) {
    if (item.id == id) return item;
  }
  return ref.watch(characterRepositoryProvider).getMergedCharacterById(id);
});
