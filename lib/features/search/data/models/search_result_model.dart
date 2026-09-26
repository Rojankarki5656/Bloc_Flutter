// lib/features/search/data/models/search_result_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/search_result.dart';

part 'search_result_model.g.dart';

@JsonSerializable()
class SearchResultModel extends SearchResult {
  const SearchResultModel({
    required super.id,
    required super.title,
    super.englishTitle,
    @JsonKey(name: 'coverImage', fromJson: _posterFromJson) super.poster,
    @JsonKey(name: 'format') super.format,
    @JsonKey(name: 'episodes') super.episodes,
    @JsonKey(name: 'averageScore') super.averageScore,
    @JsonKey(name: 'status') super.status,
    @JsonKey(name: 'startDate', fromJson: _yearFromJson) super.year,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultModelToJson(this);

  static String? _posterFromJson(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return value['large'] ?? value['medium'] as String?;
    }
    return null;
  }

  static int? _yearFromJson(Map<String, dynamic>? value) {
    return value?['year'];
  }
}