import '../entities/home_data.dart';
import '../repository/i_anime_repository.dart';

class GetHomeDataUseCase {
  final IAnimeRepository repository;

  GetHomeDataUseCase(this.repository);

  Future<HomeData> call() => repository.getHomeData();
}