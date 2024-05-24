import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/common/loader.dart';
import 'package:messenger_app/features/chat/controller/chat_controller.dart';
import 'package:messenger_app/features/chat/screens/mobile_chat_screen.dart';
import 'package:messenger_app/models/chat_contact.dart';
import 'package:messenger_app/widgets/colors.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).chatContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              const Loader();
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  var chatContactData = snapshot.data![index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            MobileChatScreen.routeName,
                            arguments: {
                              'name': chatContactData.name,
                              'uid': chatContactData.contactId,
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(
                              chatContactData.name,
                              style: const TextStyle(fontSize: 15),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                chatContactData.lastMessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                chatContactData.profilePic,
                              ),
                              radius: 30,
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(chatContactData.timeSent),
                              style: const TextStyle(
                                  color: greyColor, fontSize: 13),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                });
          }),
    );
  }
}
