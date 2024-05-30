// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger_app/common/utils/utils.dart';
import 'package:messenger_app/models/user_model.dart';
import 'package:messenger_app/features/chat/screens/mobile_chat_screen.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;
  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContactList() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhone =
            selectedContact.phones[0].number.replaceAll(' ', '').trim();
        String formatPhone = userData.phoneNumber.replaceAll('+84', '0').trim();
        // ignore: avoid_print
        print('PhoneSelected: $selectedPhone, Cloud Phone: $formatPhone ');
        if (selectedPhone == '$formatPhone') {
          isFound = true;
          if (context.mounted) {
            Navigator.pushNamed(context, MobileChatScreen.routeName,
                arguments: {
                  'name': userData.name,
                  'uid': userData.uid,
                });
          }
        }
      }
      if (!isFound) {
        if (context.mounted) {
          showSnackBar(
              context: context, content: 'Không tìm thấy liên hệ này.');
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }
}
