import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger_app/common/error.dart';
import 'package:messenger_app/common/loader.dart';
import 'package:messenger_app/features/select_contacts/controller/select_contact_controller.dart';
import 'package:messenger_app/features/select_contacts/repository/select_contact_repository.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactScreen({super.key});

  void selectedContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactRepositoryProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh bạ'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () => selectedContact(ref, contact, context),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(fontSize: 18),
                        ),
                        leading: contact.photo == null
                            ? null
                            : CircleAvatar(
                                backgroundImage: MemoryImage(contact.photo!),
                                radius: 30),
                      ),
                    ),
                  );
                }),
            error: (error, trace) => ErrorScreen(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
