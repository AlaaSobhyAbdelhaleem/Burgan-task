import 'dart:async';

import 'package:burgan_task/features/articles/article_handler.dart';
import 'package:burgan_task/features/articles/article_item.dart';
import 'package:burgan_task/features/articles/article_loading_view.dart';
import 'package:burgan_task/features/auth/login_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:burgan_task/features/articles/articles_viewmodel.dart';
import 'package:burgan_task/redux/action_report.dart';
import 'package:burgan_task/redux/app/app_state.dart';

class ArticlesView extends StatefulWidget {
  const ArticlesView({super.key});

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ArticlesViewModel>(
      distinct: true,
      converter: (store) => ArticlesViewModel.fromStore(store),
      builder: (_, viewModel) => ArticlesViewContent(
        viewModel: viewModel,
      ),
    );
  }
}

class ArticlesViewContent extends StatefulWidget {
  final ArticlesViewModel viewModel;
  const ArticlesViewContent({super.key, required this.viewModel});

  @override
  State<ArticlesViewContent> createState() => _ArticlesViewContentState();
}

class _ArticlesViewContentState extends State<ArticlesViewContent> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late ArticleHandler articleHandler;

  @override
  void initState() {
    super.initState();
    articleHandler = ArticleHandler(viewModel: widget.viewModel);
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      articleHandler.fetchData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginView(),
                      ),
                      (route) => false);
                });
              },
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
        title: Text(
          'Popular Articles',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: false,
      ),
      body: widget.viewModel.getArticlesReport.status == ActionStatus.running
          ? const ArticleLoadingView()
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (articleHandler.isDisconnected ?? false)
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.cloud_off_outlined,
                                color: Colors.grey,
                                size: 30,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                "You are offline",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    itemCount: widget.viewModel.articles.length,
                    itemBuilder: (context, index) {
                      final article = widget.viewModel.articles[index];
                      return ArticleItem(article: article);
                    },
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(
                      height: 12,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
