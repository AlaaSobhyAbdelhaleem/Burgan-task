import '../../data/model/user_model.dart';
import '../action_report.dart';

class AuthState {
  final Map<String, ActionReport>? status;
  final User? user;

  AuthState({
    this.status,
    this.user,
  });

  factory AuthState.initial() {
    return AuthState(
      status: <String, ActionReport>{},
      user: null,
    );
  }

  AuthState copyWith({
    Map<String, ActionReport>? status,
    final User? user,
  }) {
    return AuthState(
      status: status ?? this.status ?? <String, ActionReport>{},
      user: user ?? this.user,
    );
  }
}
