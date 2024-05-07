import 'package:burgan_task/data/model/article_model.dart';
import 'package:burgan_task/data/model/media_meta_data_model.dart';
import 'package:burgan_task/data/model/media_model.dart';
import 'package:burgan_task/features/articles/articles_viewmodel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ArticleHandler {
  final ArticlesViewModel? viewModel;
  ArticleHandler({this.viewModel});

  static const String tableName = 'articles';
  bool? isDisconnected;
  static Future<Database> open() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'popular_articles.db');
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE articles(id INTEGER PRIMARY KEY, published_date TEXT, title TEXT, byline TEXT, abstract TEXT, section TEXT)",
      );
      await db.execute(
        "CREATE TABLE media(id INTEGER PRIMARY KEY, article_id INTEGER, FOREIGN KEY(article_id) REFERENCES articles(id))",
      );
      await db.execute(
        "CREATE TABLE media_metadata(id INTEGER PRIMARY KEY, media_id INTEGER, url TEXT, format TEXT, height INTEGER, width INTEGER, FOREIGN KEY(media_id) REFERENCES media(id))",
      );
    });
  }

  Future<void> saveArticles(List<Article> articles) async {
    final Database db = await open();
    await db.transaction((txn) async {
      for (var article in articles) {
        int articleId = await txn.insert(
          'articles',
          {
            'id': article.id,
            'published_date': article.publishedDate,
            'title': article.title,
            'abstract': article.content,
            'byline': article.byline,
            'section': article.section,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        if (article.media != null) {
          for (var media in article.media!) {
            int mediaId = await txn.insert(
              'media',
              {
                'article_id': articleId,
              },
            );

            for (var metaData in media.mediaMetaData!) {
              await txn.insert(
                'media_metadata',
                {
                  'media_id': mediaId,
                  'url': metaData.url,
                  'format': metaData.format,
                  'height': metaData.height,
                  'width': metaData.width,
                },
              );
            }
          }
        }
      }
    });
  }

  Future<void> insertArticlesToLocal(List<Article> articles) async {
    await saveArticles(articles);
  }

  Future<List<Media>> getMediaByArticleId(int articleId) async {
    final Database db = await open();
    final List<Map<String, dynamic>> mediaMaps = await db.query(
      'media',
      where: 'article_id = ?',
      whereArgs: [articleId],
    );

    List<Media> mediaList = [];

    for (var mediaMap in mediaMaps) {
      int mediaId = mediaMap['id'];
      List<Map<String, dynamic>> metadataMaps = await db.query(
        'media_metadata',
        where: 'media_id = ?',
        whereArgs: [mediaId],
      );

      List<MediaMetaData> metadataList = metadataMaps.map((map) {
        return MediaMetaData(
          url: map['url'],
          format: map['format'],
          height: map['height'],
          width: map['width'],
        );
      }).toList();

      mediaList.add(Media(mediaMetaData: metadataList));
    }

    return mediaList;
  }

  Future<List<Article>> getSavedArticles() async {
    final Database db = await open();
    final List<Map<String, dynamic>> maps = await db.query('articles');

    List<Article> articles = [];

    for (var map in maps) {
      int articleId = map['id'];
      List<Media> mediaList = await getMediaByArticleId(articleId);

      articles.add(
        Article(
          id: map['id'],
          publishedDate: map['published_date'],
          title: map['title'],
          content: map['abstract'],
          byline: map['byline'],
          section: map['section'],
          media: mediaList,
        ),
      );
    }

    return articles;
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.none);
  }

  fetchData() async {
    isDisconnected = await checkConnectivity();

    if (isDisconnected ?? false) {
      insertArticlesToLocal(viewModel!.articles);
      List<Article> articles = await getSavedArticles();
      viewModel!.syncArticles!(articles);
    } else {
      viewModel!.getArticles();
    }
  }
}
