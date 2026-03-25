import 'package:connectivity_plus/connectivity_plus.dart';
import '../datasources/character_local_data_source.dart';
import '../datasources/character_remote_data_source.dart';
import '../models/character_edit_model.dart';
import '../models/character_model.dart';

class CharacterRepository {
  final CharacterRemoteDataSource remote;
  final CharacterLocalDataSource local;
  final Connectivity connectivity;

  CharacterRepository({
    required this.remote,
    required this.local,
    required this.connectivity,
  });

  Future<List<CharacterModel>> fetchNextPage({required int page}) async {
    final response = await remote.fetchCharacters(page: page);
    await local.cacheCharacters(response.results);
    await local.saveNextPage(response.nextPage);
    return response.results.map(_mergeCharacter).toList();
  }

  Future<bool> isOffline() async {
    final result = await connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.none);
  }

  List<CharacterModel> getCachedMergedCharacters() {
    return local.getCachedCharacters().map(_mergeCharacter).toList();
  }

  CharacterModel? getMergedCharacterById(int id) {
    final character = local.getCachedCharacter(id);
    if (character == null) return null;
    return _mergeCharacter(character);
  }

  int? getNextPageFromCache() => local.getNextPage();

  List<int> getFavoriteIds() => local.getFavoriteIds();

  Future<void> toggleFavorite(int id) async {
    final ids = local.getFavoriteIds();
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    await local.saveFavoriteIds(ids);
  }

  Future<void> saveEdit(CharacterEditModel edit) => local.saveEdit(edit);

  Future<void> resetEdit(int id) => local.removeEdit(id);

  List<CharacterModel> getFavoriteCharacters() {
    final ids = local.getFavoriteIds().toSet();
    return local
        .getCachedCharacters()
        .where((character) => ids.contains(character.id))
        .map(_mergeCharacter)
        .toList();
  }

  CharacterModel _mergeCharacter(CharacterModel base) {
    final edit = local.getEdit(base.id);
    if (edit == null) return base;

    return base.copyWith(
      name: edit.name ?? base.name,
      status: edit.status ?? base.status,
      species: edit.species ?? base.species,
      type: edit.type ?? base.type,
      gender: edit.gender ?? base.gender,
      origin: base.origin.copyWith(name: edit.originName ?? base.origin.name),
      location:
          base.location.copyWith(name: edit.locationName ?? base.location.name),
    );
  }
}
