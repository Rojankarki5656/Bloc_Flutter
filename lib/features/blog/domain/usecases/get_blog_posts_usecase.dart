import '../entities/blog_post.dart';

class GetBlogPostsUseCase {
  Future<List<BlogPost>> call() async {
    return [
      BlogPost(
        id: '1',
        slug: 'seasonal-anime-worth-watching',
        title: 'The Seasonal Anime Worth Watching',
        excerpt:
            'A concise guide to the standout series bringing fresh energy to this season.',
        author: 'Animeweebs Editorial',
        date: DateTime(2026, 9, 5),
        tags: ['Seasonal', 'Recommendations'],
      ),
      BlogPost(
        id: '2',
        slug: 'how-to-find-your-next-favorite',
        title: 'How to Find Your Next Favorite Anime',
        excerpt:
            'Use genres, themes, and a little curiosity to turn your watchlist into a better journey.',
        author: 'Mika Tanaka',
        date: DateTime(2026, 8, 28),
        tags: ['Discovery', 'Guide'],
      ),
      BlogPost(
        id: '3',
        slug: 'anime-openings-that-stay-with-you',
        title: 'Anime Openings That Stay With You',
        excerpt:
            'These opening themes do more than start an episode: they set the entire mood.',
        author: 'Ren Aoki',
        date: DateTime(2026, 8, 19),
        tags: ['Music', 'Culture'],
      ),
    ];
  }
}