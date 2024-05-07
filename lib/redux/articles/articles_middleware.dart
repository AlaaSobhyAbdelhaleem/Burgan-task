import 'package:burgan_task/features/articles/article_handler.dart';
import 'package:redux/redux.dart';
import 'package:burgan_task/data/network_common.dart';
import 'package:burgan_task/data/remote/article_repository.dart';
import 'package:burgan_task/redux/action_report.dart';
import 'package:burgan_task/redux/app/app_state.dart';
import 'package:burgan_task/redux/articles/articles_actions.dart';

List<Middleware<AppState>> createArticleMiddleware([
  ArticleRepository? repository,
]) {
  repository = ArticleRepository(NetworkCommon().dio);
  final getArticles = _getArticles(repository);

  return [
    TypedMiddleware<AppState, GetArticlesAction>(getArticles).call,
  ];
}

Middleware<AppState> _getArticles(ArticleRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.getArticles().then((result) {
      next(SyncArticlesAction(articles: result.articles));
      ArticleHandler().insertArticlesToLocal(result.articles);
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

void catchError(NextDispatcher next, action, error) {
  next(ArticlesStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "${action.actionName} is error;${error.toString()}")));
}

void completed(NextDispatcher next, action) {
  next(ArticlesStatusAction(
      report: ActionReport(
          actionName: action.actionName, status: ActionStatus.complete, msg: "${action.actionName} is completed")));
}

void noMoreItem(NextDispatcher next, action) {
  next(ArticlesStatusAction(
      report: ActionReport(actionName: action.actionName, status: ActionStatus.complete, msg: "no more items")));
}

void running(NextDispatcher next, action) {
  next(ArticlesStatusAction(
      report: ActionReport(
          actionName: action.actionName, status: ActionStatus.running, msg: "${action.actionName} is running")));
}

void idEmpty(NextDispatcher next, action) {
  next(ArticlesStatusAction(
      report: ActionReport(actionName: action.actionName, status: ActionStatus.error, msg: "Id is empty")));
}
