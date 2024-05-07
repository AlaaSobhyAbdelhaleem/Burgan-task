import 'package:burgan_task/data/model/article_model.dart';
import 'package:burgan_task/redux/action_report.dart';

class ArticlesStatusAction {
  final String actionName = "ArticlesStatusAction";
  final ActionReport? report;

  ArticlesStatusAction({this.report});
}

class GetArticlesAction {
  final String actionName = "GetArticlesAction";

  GetArticlesAction();
}

class SyncArticlesAction {
  final String actionName = "SyncArticlesAction";
  final List<Article> articles;
  SyncArticlesAction({required this.articles});
}
