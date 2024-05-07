import 'package:burgan_task/redux/articles/articles_state.dart';
import 'package:burgan_task/redux/auth/auth_state.dart';

class AppState {
  final ArticlesState articlesState;
  final AuthState authState;

  AppState({
    required this.articlesState,
    required this.authState,
  });

  factory AppState.initial() {
    return AppState(
      articlesState: ArticlesState.initial(),
      authState: AuthState.initial(),
    );
  }
}
