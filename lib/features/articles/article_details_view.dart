import 'package:burgan_task/gen/assets.gen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:burgan_task/data/model/article_model.dart';
import 'package:burgan_task/widgets/back_button_widget.dart';

class ArticleDetailView extends StatelessWidget {
  final Article article;

  const ArticleDetailView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          article.section,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: const BackButtonWidget(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                article.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      article.byline,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    article.publishedDate ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              if (article.media?.isNotEmpty ?? false)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: article.media?[0].mediaMetaData?[2].url ?? '',
                    progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      Assets.images.articleImage.path,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 25),
              Text(
                article.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
