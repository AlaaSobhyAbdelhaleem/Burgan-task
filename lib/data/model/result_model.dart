import 'package:json_annotation/json_annotation.dart';
import 'package:burgan_task/data/model/article_model.dart';
part 'result_model.g.dart';

@JsonSerializable(createToJson: false)
class Result {
  @JsonKey(name: "results")
  List<Article> articles;

  Result({
    required this.articles,
  });
  factory Result.fromJson(Map<String, dynamic> json) {
    return _$ResultFromJson(json);
  }
}
