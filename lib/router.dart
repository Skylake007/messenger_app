import 'package:flutter/material.dart';
import 'package:messenger_app/common/error.dart';
import 'package:messenger_app/features/landing/screens/auth/screens/login_screen.dart';
import 'package:messenger_app/features/landing/screens/auth/screens/otp_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(verificationId: verificationId),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(
            error: 'Trang này không tồn tại!',
          ),
        ),
      );
  }
}
