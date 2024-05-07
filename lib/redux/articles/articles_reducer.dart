import 'package:burgan_task/redux/articles/articles_actions.dart';
import 'package:burgan_task/redux/articles/articles_state.dart';
import 'package:redux/redux.dart';

final articleReducer = combineReducers<ArticlesState>([
  TypedReducer<ArticlesState, ArticlesStatusAction>(_articleStatus).call,
  TypedReducer<ArticlesState, SyncArticlesAction>(_syncArticles).call,
]);

ArticlesState _articleStatus(ArticlesState state, ArticlesStatusAction action) {
  var status = state.status;
  status!.update(action.report!.actionName!, (v) => action.report!, ifAbsent: () => action.report!);
  return state.copyWith(status: status);
}

ArticlesState _syncArticles(ArticlesState state, SyncArticlesAction action) {
  state.articles = action.articles;
  return state.copyWith(articles: state.articles);
}
