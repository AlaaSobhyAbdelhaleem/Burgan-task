import 'package:burgan_task/data/remote/auth_repository.dart';
import 'package:burgan_task/redux/app/app_state.dart';
import 'package:redux/redux.dart';

import '../action_report.dart';
import 'auth_actions.dart';

List<Middleware<AppState>> createAuthMiddleware([
  AuthRepository repository = const AuthRepository(),
]) {
  final login = _login(repository);
  final loginwithBiometric = _loginwithBiometric(repository);
  final signup = _signup(repository);

  return [
    TypedMiddleware<AppState, LoginAction>(login).call,
    TypedMiddleware<AppState, SignupAction>(signup).call,
    TypedMiddleware<AppState, LoginWithBiometricAction>(loginwithBiometric).call,
  ];
}

Middleware<AppState> _login(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.login(action.user).then((user) {
      if (user != null) {
        next(SyncUserAction(user: user));
        completed(next, action);
      } else {
        catchError(next, action, "Please verify your email address");
      }
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _loginwithBiometric(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.loginWithBiometric().then((_) {
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _signup(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.signup(action.user).then((user) {
      next(SyncUserAction(user: user));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

void catchError(NextDispatcher next, action, error) {
  next(
    AuthStatusAction(
      report: ActionReport(actionName: action.actionName, status: ActionStatus.error, msg: error.toString()),
    ),
  );
}

void completed(NextDispatcher next, action) {
  next(AuthStatusAction(
      report: ActionReport(
          actionName: action.actionName, status: ActionStatus.complete, msg: "${action.actionName} is completed")));
}

void running(NextDispatcher next, action) {
  next(AuthStatusAction(
      report: ActionReport(
          actionName: action.actionName, status: ActionStatus.running, msg: "${action.actionName} is running")));
}

void idEmpty(NextDispatcher next, action) {
  next(AuthStatusAction(
      report: ActionReport(actionName: action.actionName, status: ActionStatus.error, msg: "Id is empty")));
}
