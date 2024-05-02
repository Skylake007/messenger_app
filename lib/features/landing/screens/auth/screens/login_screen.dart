import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger_app/common/custom_button.dart';
import 'package:messenger_app/common/utils/utils.dart';
import 'package:messenger_app/features/landing/screens/auth/controller/auth_controller.dart';
import 'package:messenger_app/widgets/colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      // ignore: no_leading_underscores_for_local_identifiers
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

/*Provider ref => Interact provider with provider
  Widget ref => makes widget interact with provider
  Provider.of(context, listen: false)
  context.read()
*/

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
      print('+${country!.phoneCode}$phoneNumber');
    } else {
      showSnackBar(
          context: context, content: 'Vui lòng nhập nhập đầy đủ thông tin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhập số điện thoại"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
                'Chúng tôi sẽ gửi tin nhắn đến số điện thoại của bạn để xác thực tài khoản.'),
            const SizedBox(height: 10),
            TextButton(
              onPressed: pickCountry,
              child: const Text('Chọn quốc gia'),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                if (country != null) Text('+${country!.phoneCode}'),
                const SizedBox(width: 10),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'nhập số điện thoại',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.58),
            SizedBox(
              width: 110,
              child: CustomButton(
                onPressed: sendPhoneNumber,
                text: 'Tiếp tục',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
