import 'package:burgan_task/data/model/article_model.dart';
import 'package:burgan_task/redux/action_report.dart';

class ArticlesState {
  final Map<String, ActionReport>? status;
  List<Article> articles;

  ArticlesState({
    this.status,
    required this.articles,
  });

  factory ArticlesState.initial() {
    return ArticlesState(status: <String, ActionReport>{}, articles: []);
  }

  ArticlesState copyWith({
    final Map<String, ActionReport>? status,
    List<Article>? articles,
  }) {
    return ArticlesState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
    );
  }
}
