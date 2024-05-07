import 'package:burgan_task/features/auth/auth_viewmodel.dart';
import 'package:burgan_task/features/auth/login_view.dart';
import 'package:burgan_task/redux/app/app_state.dart';
import 'package:burgan_task/utils/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:burgan_task/gen/assets.gen.dart';
import 'package:burgan_task/widgets/back_button_widget.dart';
import 'package:burgan_task/widgets/custom_button.dart';
import 'package:flutter_redux/flutter_redux.dart';

class EmailVerificationView extends StatelessWidget {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthViewModel>(
      distinct: true,
      converter: (store) => AuthViewModel.fromStore(store),
      builder: (_, viewModel) => EmailVerificationViewContent(
        viewModel: viewModel,
      ),
    );
  }
}

class EmailVerificationViewContent extends StatefulWidget {
  final AuthViewModel viewModel;
  const EmailVerificationViewContent({super.key, required this.viewModel});

  @override
  State<EmailVerificationViewContent> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationViewContent> {
  String otp = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                    Assets.images.emailVerification.path,
                    height: 300,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Verify your email address",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Confirm your email address with the email we sent to: ",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.viewModel.user?.email ?? '',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),
                ),
                const SizedBox(
                  height: 30,
                ),
                ButtonWidget(
                  type: ButtonType.primary,
                  onTap: () {
                    _sendVerificationEmail();
                  },
                  title: "Resend email",
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginView(),
                          ),
                          (route) => false);
                    },
                    child: Text(
                      "Back To Login",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendVerificationEmail() async {
    User user = _auth.currentUser!;
    try {
      await user.sendEmailVerification();
    } catch (e) {
      setState(() {
        showSnackBar(context, e.toString());
      });
    }
  }
}
