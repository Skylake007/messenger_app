// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;

  const OTPScreen({
    super.key,
    required this.verificationId,
  });
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
