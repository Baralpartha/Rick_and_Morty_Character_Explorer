import 'package:dio/dio.dart';
import '../models/paginated_characters_response.dart';

class CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSource(this.dio);

  Future<PaginatedCharactersResponse> fetchCharacters({required int page}) async {
    final response = await dio.get('/character', queryParameters: {'page': page});
    return PaginatedCharactersResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
