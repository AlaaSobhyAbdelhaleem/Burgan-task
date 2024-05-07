import 'package:burgan_task/data/model/user_model.dart';
import 'package:burgan_task/features/articles/articles_view.dart';
import 'package:burgan_task/features/auth/auth_viewmodel.dart';
import 'package:burgan_task/redux/action_report.dart';
import 'package:burgan_task/redux/app/app_state.dart';
import 'package:burgan_task/utils/progress_dialog.dart';
import 'package:burgan_task/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:burgan_task/features/auth/signup_view.dart';
import 'package:burgan_task/gen/assets.gen.dart';
import 'package:burgan_task/widgets/custom_button.dart';
import 'package:burgan_task/widgets/custom_textField.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthViewModel>(
      distinct: true,
      converter: (store) => AuthViewModel.fromStore(store),
      builder: (_, viewModel) => LoginViewContent(
        viewModel: viewModel,
      ),
    );
  }
}

class LoginViewContent extends StatefulWidget {
  final AuthViewModel viewModel;
  const LoginViewContent({super.key, required this.viewModel});

  @override
  State<LoginViewContent> createState() => _ArticlesListContentState();
}

class _ArticlesListContentState extends State<LoginViewContent> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  ProgressDialog? progressDialog;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool authenticated = false;
  bool enabledFingerPrint = false;
  bool supportFingerPrint = false;

  @override
  Future<void> didChangeDependencies() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      enabledFingerPrint = prefs.getBool("enableFingerPrint") ?? false;
      supportFingerPrint = prefs.getBool("isSupported") ?? false;
    });
    super.didChangeDependencies();
  }

  Future<void> _authenticateMe() async {
    try {
      authenticated = await _localAuthentication
          .authenticate(
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
        localizedReason: 'Scan your fingerprint to authenticate',
      )
          .then((value) async {
        if (value) {
          widget.viewModel.loginWithBiometric();
        }
        return value;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;
  }

  @override
  void didUpdateWidget(LoginViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () {
      if (widget.viewModel.loginReport.status == ActionStatus.running) {
        progressDialog ??= ProgressDialog(context);
        if (!progressDialog!.isShowing()) {
          progressDialog!.setMessage("Processing...");
          progressDialog!.show();
        }
      } else if (widget.viewModel.loginReport.status == ActionStatus.error) {
        if (progressDialog != null && progressDialog!.isShowing()) {
          progressDialog!.hide();
          progressDialog = null;
        }
        showSnackBar(context, widget.viewModel.loginReport.msg.toString());
        widget.viewModel.loginReport.status = null;
      } else if (widget.viewModel.loginReport.status == ActionStatus.complete) {
        if (progressDialog != null && progressDialog!.isShowing()) {
          progressDialog!.hide();
          progressDialog = null;
        }
        widget.viewModel.loginReport.status = null;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const ArticlesView(),
            ),
            (route) => false);
      } else {
        if (progressDialog != null && progressDialog!.isShowing()) {
          progressDialog!.hide();
          progressDialog = null;
        }
      }
      widget.viewModel.loginReport.status = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    Assets.images.login.path,
                    height: 320,
                  ),
                ),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFieldWidget(
                        type: TextFieldType.text,
                        hint: "Email",
                        controller: email,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFieldWidget(
                        type: TextFieldType.password,
                        hint: "Password",
                        controller: password,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        type: ButtonType.primary,
                        onTap: () {
                          User user = User(email: email.text, password: password.text);
                          widget.viewModel.login(user);
                        },
                        title: "Login",
                      ),
                    ),
                    !supportFingerPrint
                        ? const SizedBox.shrink()
                        : Opacity(
                            opacity: !enabledFingerPrint ? 0.5 : 1,
                            child: IconButton(
                              onPressed: () {
                                if (enabledFingerPrint) {
                                  _authenticateMe();
                                }
                              },
                              icon: Container(
                                height: 56,
                                width: 56,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: const Icon(
                                  Icons.fingerprint,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have account?",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpView(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
