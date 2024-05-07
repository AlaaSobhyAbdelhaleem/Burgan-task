import 'package:burgan_task/redux/articles/articles_reducer.dart';
import 'package:burgan_task/redux/auth/auth_reducer.dart';

import 'app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    articlesState: articleReducer(state.articlesState, action),
    authState: authReducer(state.authState, action),
  );
}
