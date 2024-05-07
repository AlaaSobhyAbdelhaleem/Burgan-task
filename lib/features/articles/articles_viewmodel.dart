import 'package:redux/redux.dart';
import 'package:burgan_task/data/model/article_model.dart';
import 'package:burgan_task/redux/action_report.dart';
import 'package:burgan_task/redux/app/app_state.dart';
import 'package:burgan_task/redux/articles/articles_actions.dart';

class ArticlesViewModel {
  final List<Article> articles;
  final Function() getArticles;
  final Function(List<Article>)? syncArticles;
  final ActionReport getArticlesReport;

  ArticlesViewModel({
    required this.articles,
    required this.getArticles,
    this.syncArticles,
    required this.getArticlesReport,
  });

  static ArticlesViewModel fromStore(Store<AppState> store) {
    return ArticlesViewModel(
      articles: store.state.articlesState.articles,
      getArticles: () => store.dispatch(GetArticlesAction()),
      syncArticles: (articles) => store.dispatch(SyncArticlesAction(articles: articles)),
      getArticlesReport: store.state.articlesState.status!['GetArticlesAction'] ?? ActionReport(),
    );
  }
}
