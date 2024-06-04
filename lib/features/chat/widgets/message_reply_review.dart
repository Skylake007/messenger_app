import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger_app/common/providers/message_reply_provider.dart';
import 'package:messenger_app/widgets/colors.dart';

class MessageReplyReview extends ConsumerWidget {
  const MessageReplyReview({super.key});

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe
                      ? 'Đang trả lời chính bạn'
                      : 'Đang trả lời:',
                  style: const TextStyle(
                    fontWeight: FontWeight.w200,
                    color: greyColor,
                  ),
                ),
              ),
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  size: 14,
                ),
                onTap: () {},
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(messageReply.message)
        ],
      ),
    );
  }
}
