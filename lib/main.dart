import 'package:burgan_task/features/splash/splash_view.dart';
import 'package:burgan_task/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:burgan_task/redux/app/app_state.dart';
import 'package:burgan_task/redux/store.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var store = await createStore();
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp(this.store, {super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.deepPurple,
          hintColor: Colors.grey.shade300,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          cardTheme: const CardTheme(
            color: Colors.white,
            elevation: 4,
            surfaceTintColor: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
          dialogTheme: const DialogTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.white,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            const TextTheme(
              headlineMedium: TextStyle(
                fontSize: 24,
                letterSpacing: 0,
                fontWeight: FontWeight.w700,
              ),
              headlineSmall: TextStyle(
                fontWeight: FontWeight.w600,
              ),
              bodyLarge: TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
              bodySmall: TextStyle(
                letterSpacing: 0,
                color: Colors.grey,
              ),
              titleLarge: TextStyle(
                fontWeight: FontWeight.w600,
              ),
              titleMedium: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.deepPurple,
                fontSize: 16,
              ),
              titleSmall: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ),
        home: const SplashView(),
      ),
    );
  }
}
