import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/character_edit_model.dart';
import '../models/character_model.dart';

class CharacterLocalDataSource {
  Box<Map> get _charactersBox => Hive.box<Map>(AppConstants.charactersBox);
  Box get _favoritesBox => Hive.box(AppConstants.favoritesBox);
  Box<Map> get _editsBox => Hive.box<Map>(AppConstants.editsBox);
  Box get _metaBox => Hive.box(AppConstants.metaBox);

  Future<void> cacheCharacters(List<CharacterModel> characters) async {
    for (final character in characters) {
      await _charactersBox.put(character.id.toString(), character.toJson());
    }
  }

  List<CharacterModel> getCachedCharacters() {
    return _charactersBox.values
        .map((e) => CharacterModel.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));
  }

  CharacterModel? getCachedCharacter(int id) {
    final raw = _charactersBox.get(id.toString());
    if (raw == null) return null;
    return CharacterModel.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<void> saveFavoriteIds(List<int> ids) async {
    await _favoritesBox.put('ids', ids);
  }

  List<int> getFavoriteIds() {
    final raw = _favoritesBox.get('ids', defaultValue: <int>[]);
    return List<int>.from(raw as List);
  }

  Future<void> saveEdit(CharacterEditModel edit) async {
    await _editsBox.put(edit.id.toString(), edit.toJson());
  }

  CharacterEditModel? getEdit(int id) {
    final raw = _editsBox.get(id.toString());
    if (raw == null) return null;
    return CharacterEditModel.fromJson(raw);
  }

  List<CharacterEditModel> getAllEdits() {
    return _editsBox.values.map(CharacterEditModel.fromJson).toList();
  }

  Future<void> removeEdit(int id) async {
    await _editsBox.delete(id.toString());
  }

  Future<void> saveNextPage(int? page) async {
    await _metaBox.put('next_page', page);
  }

  int? getNextPage() {
    final value = _metaBox.get('next_page');
    return value is int ? value : null;
  }
}
