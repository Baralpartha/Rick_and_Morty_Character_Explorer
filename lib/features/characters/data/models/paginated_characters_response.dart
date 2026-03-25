import 'character_model.dart';

class PaginatedCharactersResponse {
  final List<CharacterModel> results;
  final int? nextPage;

  const PaginatedCharactersResponse({
    required this.results,
    required this.nextPage,
  });

  factory PaginatedCharactersResponse.fromJson(Map<String, dynamic> json) {
    final info = (json['info'] ?? {}) as Map<String, dynamic>;
    final results = ((json['results'] ?? []) as List)
        .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final nextUrl = info['next'] as String?;
    int? nextPage;
    if (nextUrl != null && nextUrl.contains('page=')) {
      nextPage = int.tryParse(nextUrl.split('page=').last);
    }

    return PaginatedCharactersResponse(results: results, nextPage: nextPage);
  }
}
