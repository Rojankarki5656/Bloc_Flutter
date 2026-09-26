import 'package:equatable/equatable.dart';

class BlogPost extends Equatable {
  final String id;
  final String slug;
  final String title;
  final String excerpt;
  final String? image;
  final String author;
  final DateTime date;
  final List<String> tags;

  const BlogPost({
    required this.id,
    required this.slug,
    required this.title,
    required this.excerpt,
    required this.author,
    required this.date,
    this.image,
    this.tags = const [],
  });

  String get formattedDate {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  List<Object?> get props => [
        id,
        slug,
        title,
        excerpt,
        image,
        author,
        date,
        tags,
      ];
}