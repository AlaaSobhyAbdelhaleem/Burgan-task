import 'package:burgan_task/data/model/user_model.dart';
import 'package:burgan_task/redux/auth/auth_actions.dart';
import 'package:redux/redux.dart';
import 'package:burgan_task/redux/action_report.dart';
import 'package:burgan_task/redux/app/app_state.dart';

class AuthViewModel {
  final User? user;
  final Function(User) login;
  final Function() loginWithBiometric;
  final ActionReport loginReport;
  final Function(User) signUp;
  final ActionReport signUpReport;

  AuthViewModel({
    this.user,
    required this.login,
    required this.loginWithBiometric,
    required this.loginReport,
    required this.signUp,
    required this.signUpReport,
  });

  static AuthViewModel fromStore(Store<AppState> store) {
    return AuthViewModel(
      user: store.state.authState.user,
      login: (user) => store.dispatch(LoginAction(user: user)),
      loginWithBiometric: () => store.dispatch(LoginWithBiometricAction()),
      signUp: (user) => store.dispatch(SignupAction(user: user)),
      loginReport: store.state.authState.status!['LoginAction'] ?? ActionReport(),
      signUpReport: store.state.authState.status!['SignupAction'] ?? ActionReport(),
    );
  }
}
