import 'package:flutter/material.dart';
import 'package:messenger_app/common/custom_button.dart';
import 'package:messenger_app/features/landing/screens/auth/screens/login_screen.dart';
import 'package:messenger_app/widgets/colors.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigatorPushLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Chào mừng bạn!',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 33,
              ),
            ),
            SizedBox(height: size.height / 9),
            Image.asset(
              'assets/bg.png',
              height: 340,
              width: 340,
            ),
            SizedBox(height: size.height / 9),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Đọc chính sách quyền riêng tư và ấn vào "Đồng ý và tiếp tục" để chấp nhận điều khoản và dịch vụ.',
                style: TextStyle(
                  color: greyColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: size.width * 0.75,
              child: CustomButton(
                text: "Đồng ý và tiếp tục.",
                onPressed: () => navigatorPushLoginScreen(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
