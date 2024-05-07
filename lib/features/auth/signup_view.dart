import 'package:burgan_task/data/model/user_model.dart';
import 'package:burgan_task/features/auth/auth_viewmodel.dart';
import 'package:burgan_task/features/auth/success_smart_link_dialog.dart';
import 'package:burgan_task/redux/action_report.dart';
import 'package:burgan_task/redux/app/app_state.dart';
import 'package:burgan_task/utils/progress_dialog.dart';
import 'package:burgan_task/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:burgan_task/features/auth/email_verification_view.dart';
import 'package:burgan_task/gen/assets.gen.dart';
import 'package:burgan_task/widgets/back_button_widget.dart';
import 'package:burgan_task/widgets/custom_button.dart';
import 'package:burgan_task/widgets/custom_textField.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthViewModel>(
      distinct: true,
      converter: (store) => AuthViewModel.fromStore(store),
      builder: (_, viewModel) => SignUpViewContent(
        viewModel: viewModel,
      ),
    );
  }
}

class SignUpViewContent extends StatefulWidget {
  final AuthViewModel viewModel;
  const SignUpViewContent({super.key, required this.viewModel});

  @override
  State<SignUpViewContent> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpViewContent> {
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  ProgressDialog? progressDialog;

  final LocalAuthentication auth = LocalAuthentication();
  bool authenticated = false;
  bool? enableFingerPrint;
  bool? supportFingerPrint = false;
  bool? enable;
  String? title;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  @override
  Future<void> didChangeDependencies() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      supportFingerPrint = prefs.getBool("isSupported") ?? false;
      enable = prefs.getBool("enableFingerPrint") ?? false;
      if (!enable!) {
        title = "Link A Smart Access";
      } else {
        title = "Smart access has been linked";
      }
    });

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SignUpViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () {
      if (widget.viewModel.signUpReport.status == ActionStatus.running) {
        progressDialog ??= ProgressDialog(context);
        if (!progressDialog!.isShowing()) {
          progressDialog!.setMessage("Processing...");
          progressDialog!.show();
        }
      } else if (widget.viewModel.signUpReport.status == ActionStatus.error) {
        if (progressDialog != null && progressDialog!.isShowing()) {
          progressDialog!.hide();
          progressDialog = null;
        }
        showSnackBar(context, widget.viewModel.signUpReport.msg.toString());
        widget.viewModel.signUpReport.status = null;
      } else if (widget.viewModel.signUpReport.status == ActionStatus.complete) {
        if (progressDialog != null && progressDialog!.isShowing()) {
          progressDialog!.hide();
          progressDialog = null;
        }
        widget.viewModel.signUpReport.status = null;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EmailVerificationView(),
          ),
        );
      } else {
        if (progressDialog != null && progressDialog!.isShowing()) {
          progressDialog!.hide();
          progressDialog = null;
        }
      }
      widget.viewModel.signUpReport.status = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Image.asset(
                  Assets.images.register.path,
                  height: 280,
                )),
                Text(
                  "Sign Up",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.person_2_outlined,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFieldWidget(
                        type: TextFieldType.text,
                        hint: "User Name",
                        controller: userName,
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
                      padding: EdgeInsets.only(top: 3),
                      child: Icon(
                        Icons.phone_outlined,
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
                        hint: "Phone",
                        controller: phone,
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
                ButtonWidget(
                  type: ButtonType.primary,
                  onTap: () {
                    User user = User(
                      username: userName.text,
                      email: email.text,
                      phone: phone.text,
                      password: password.text,
                    );
                    widget.viewModel.signUp(user);
                  },
                  title: "Continue",
                ),
                !supportFingerPrint!
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: ButtonWidget(
                            type: ButtonType.secondary,
                            title: title,
                            onTap: () async {
                              if (!enable!) {
                                try {
                                  await _localAuthentication
                                      .authenticate(
                                          options: const AuthenticationOptions(
                                              useErrorDialogs: true, stickyAuth: true, biometricOnly: true),
                                          localizedReason: 'Scan your fingerprint to authenticate')
                                      .then(
                                    (value) async {
                                      if (value) {
                                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                                        setState(
                                          () {
                                            enableFingerPrint = value;
                                            prefs.setBool("enableFingerPrint", enableFingerPrint!);
                                            enable = true;
                                            title = "Smart access has been linked";
                                          },
                                        );
                                        if (enableFingerPrint!) {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return const SuccessFingerprintLinkDialog();
                                              });
                                        }
                                      }
                                    },
                                  );
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              }
                            }),
                      ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account?",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login",
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
