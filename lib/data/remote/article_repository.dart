import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:burgan_task/data/model/result_model.dart';

part 'article_repository.g.dart';

@RestApi()
abstract class ArticleRepository {
  factory ArticleRepository(Dio dio) = _ArticleRepository;

  @GET("emailed/1.json?api-key={apiKey}")
  Future<Result> getArticles(
    @Path("apiKey") String apiKey,
  );
}
