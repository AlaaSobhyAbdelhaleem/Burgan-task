import 'dart:async';
import 'package:burgan_task/features/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool supportState = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    _localAuthentication.isDeviceSupported().then((bool isSupported) async {
      setState(() {
        supportState = isSupported;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isSupported", supportState);
    });

    super.didChangeDependencies();
  }

  Future<Timer> loadData() async {
    return Timer(const Duration(seconds: 1), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
