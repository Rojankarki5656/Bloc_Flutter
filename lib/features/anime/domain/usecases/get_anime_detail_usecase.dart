// lib/features/anime/domain/usecases/get_anime_detail_usecase.dart
import '../entities/anime.dart';
import '../repository/i_anime_repository.dart';
import '../entities/character.dart';
import '../entities/relation.dart';

class GetAnimeDetailUseCase {
  final IAnimeRepository repository;

  GetAnimeDetailUseCase(this.repository);

  Future<AnimeDetailResult> call(String id) async {
    try {
      final anime = await repository.getAnimeDetail(int.parse(id));
      // If your repository returns a different structure, adjust accordingly
      // For now, assuming it returns AnimeDetailResult
      return AnimeDetailResult(
        anime: anime,
        characters: [],
        relations: [],
      );
    } catch (e) {
      throw Exception('Failed to get anime detail: $e');
    }
  }
}

class AnimeDetailResult {
  final Anime anime;
  final List<Character> characters;
  final List<Relation> relations;

  const AnimeDetailResult({
    required this.anime,
    required this.characters,
    required this.relations,
  });
}
