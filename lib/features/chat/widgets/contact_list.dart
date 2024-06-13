import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/common/error.dart';
import 'package:messenger_app/common/loader.dart';
import 'package:messenger_app/features/chat/controller/chat_controller.dart';
import 'package:messenger_app/features/chat/screens/mobile_chat_screen.dart';
import 'package:messenger_app/features/chat/widgets/empty_message.dart';
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
            return const Loader();
          }

          if (snapshot.hasError) {
            return ErrorScreen(error: snapshot.error.toString());
          }

          final contacts = snapshot.data;
          if (contacts == null || contacts.isEmpty) {
            return const EmptyMessage();
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              var chatContactData = contacts[index];
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
                          'userImage': chatContactData.profilePic
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                chatContactData.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 15),
                              ),
                              Text(
                                DateFormat.Hm()
                                    .format(chatContactData.timeSent),
                                style: const TextStyle(
                                  color: greyColor,
                                  fontSize: 13,
                                ),
                              ),
                            ]),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            chatContactData.lastMessage,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            chatContactData.profilePic,
                          ),
                          radius: 30,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
