import '../../data/model/user_model.dart';
import '../action_report.dart';

class AuthStatusAction {
  final String actionName = "AuthStatusAction";
  final ActionReport? report;

  AuthStatusAction({required this.report});
}

class LoginAction {
  final String? actionName = "LoginAction";
  final User user;
  LoginAction({
    required this.user,
  });
}

class LoginWithBiometricAction {
  final String? actionName = "LoginAction";
  LoginWithBiometricAction();
}

class SignupAction {
  final String? actionName = "SignupAction";
  final User user;

  SignupAction({
    required this.user,
  });
}

class SyncUserAction {
  final String? actionName = "SyncUserAction";
  final User user;

  SyncUserAction({required this.user});
}
