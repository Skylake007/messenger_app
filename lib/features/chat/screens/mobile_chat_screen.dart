// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:messenger_app/common/loader.dart';
import 'package:messenger_app/features/auth/controller/auth_controller.dart';
import 'package:messenger_app/features/chat/widgets/bottom_chat_field.dart';
import 'package:messenger_app/features/chat/widgets/chat_list.dart';
import 'package:messenger_app/models/user_model.dart';
import 'package:messenger_app/widgets/colors.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final String userImage;
  const MobileChatScreen({
    super.key,
    required this.name,
    required this.uid,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    snapshot.data!.isOnline ? 'Đang hoạt động' : '',
                    style: const TextStyle(fontSize: 12, color: greyColor),
                  )
                ],
              );
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverUserId: uid,
              recieverImage: userImage,
            ),
          ),
          BottomChatField(
            recieverUserId: uid,
          ),
        ],
      ),
    );
  }
}
