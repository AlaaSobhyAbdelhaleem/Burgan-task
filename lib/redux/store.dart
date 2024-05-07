import 'package:burgan_task/redux/articles/articles_middleware.dart';
import 'package:burgan_task/redux/auth/auth_middleware.dart';

import 'app/app_reducer.dart';
import 'app/app_state.dart';
import 'package:redux/redux.dart';

Future<Store<AppState>> createStore() async {
  return Store(appReducer, initialState: AppState.initial(), middleware: [
    ...createArticleMiddleware(),
    ...createAuthMiddleware(),
  ]);
}
