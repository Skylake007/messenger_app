// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:messenger_app/features/chat/controller/chat_controller.dart';
import 'package:messenger_app/info.dart';
import 'package:messenger_app/widgets/my_message_card.dart';
import 'package:messenger_app/widgets/sender_message_card.dart';

class ChatList extends ConsumerWidget {
  final String recieverUserId;
  const ChatList({
    super.key,
    required this.recieverUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref.read(chatControllerProvider).chatStream(recieverUserId),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                if (messages[index]['isMe'] == true) {
                  return MyMessageCard(
                    message: messages[index]['text'].toString(),
                    date: messages[index]['time'].toString(),
                  );
                }
                return SenderMessageCard(
                  message: messages[index]['text'].toString(),
                  date: messages[index]['time'].toString(),
                );
              });
        });
  }
}
