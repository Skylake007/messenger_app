// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:messenger_app/common/enums/message_enum.dart';
import 'package:messenger_app/common/loader.dart';
import 'package:messenger_app/common/providers/message_reply_provider.dart';
import 'package:messenger_app/features/chat/controller/chat_controller.dart';
import 'package:messenger_app/features/chat/widgets/my_message_card.dart';
import 'package:messenger_app/features/chat/widgets/sender_message_card.dart';
import 'package:messenger_app/models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final String recieverImage;

  const ChatList({
    super.key,
    required this.recieverUserId,
    required this.recieverImage,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController scrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
            isMe: isMe,
            message: message,
            messageEnum: messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            }
          });

          return ListView.builder(
              controller: scrollController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final messageData = snapshot.data![index];
                var timeSent = DateFormat.Hm().format(messageData.timeSent);
                if (!messageData.isSeen &&
                    messageData.recieverId ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  ref.read(chatControllerProvider).setChatMessageSeen(
                      context, widget.recieverUserId, messageData.messageId);
                }
                if (messageData.senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyMessageCard(
                    message: messageData.text,
                    date: timeSent,
                    type: messageData.type,
                    repliedText: messageData.repliedMessage,
                    username: messageData.repliedTo,
                    repliedMessageType: messageData.repliedMessageType,
                    onLeftSwipeCallBack: () => onMessageSwipe(
                      messageData.text,
                      true,
                      messageData.type,
                    ),
                    isSeen: messageData.isSeen,
                    userImage: widget.recieverImage,
                  );
                }
                return SenderMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.type,
                  repliedText: messageData.repliedMessage,
                  username: messageData.repliedTo,
                  repliedMessageType: messageData.repliedMessageType,
                  onRightSwipeCallBack: () => onMessageSwipe(
                    messageData.text,
                    false,
                    messageData.type,
                  ),
                  isSeen: messageData.isSeen,
                );
              });
        });
  }
}
