import 'package:flutter/material.dart';
import 'package:messenger_app/common/error.dart';
import 'package:messenger_app/features/auth/screens/login_screen.dart';
import 'package:messenger_app/features/auth/screens/otp_screen.dart';
import 'package:messenger_app/features/auth/screens/user_information_screen.dart';
import 'package:messenger_app/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:messenger_app/features/chat/screens/mobile_chat_screen.dart';

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

    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );

    case SelectContactScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactScreen(),
      );

    case MobileChatScreen.routeName:
      final agruments = settings.arguments as Map<String, dynamic>;
      final name = agruments['name'];
      final uid = agruments['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
        ),
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
