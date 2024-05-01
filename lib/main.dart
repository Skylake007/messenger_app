import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger_app/features/landing/screens/landing_screen.dart';
import 'package:messenger_app/firebase_options.dart';
import 'package:messenger_app/router.dart';
import 'package:messenger_app/widgets/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  details.exception.toString(),
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ],
            ),
          ),
        ),
      );
    };
    return MaterialApp(
      title: 'Messenger Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const LandingScreen(),
    );
  }
}
