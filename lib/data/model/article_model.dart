import 'package:json_annotation/json_annotation.dart';
import 'package:burgan_task/data/model/media_model.dart';

part 'article_model.g.dart';

@JsonSerializable()
class Article {
  int id;
  @JsonKey(name: 'published_date')
  String? publishedDate;
  String title;
  @JsonKey(name: "abstract")
  String content;
  String byline;
  List<Media>? media;
  String section;

  Article({
    required this.id,
    required this.publishedDate,
    required this.title,
    required this.content,
    required this.byline,
    required this.media,
    required this.section,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return _$ArticleFromJson(json);
  }
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
