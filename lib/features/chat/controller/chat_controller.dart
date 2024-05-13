import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger_app/features/auth/controller/auth_controller.dart';
import 'package:messenger_app/features/chat/repositories/chat_repository.dart';

final chatControllerProvider = Provider(
  (ref) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    return ChatController(
      chatRepository: chatRepository,
      ref: ref,
    );
  },
);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (data) => chatRepository.sentTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: data!,
          ),
        );
  }
}