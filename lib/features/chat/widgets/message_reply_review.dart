import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger_app/common/enums/message_enum.dart';
import 'package:messenger_app/common/providers/message_reply_provider.dart';
import 'package:messenger_app/features/chat/widgets/display_text_image_gif.dart';
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
      padding: const EdgeInsets.only(
        top: 12,
        left: 0,
        bottom: 12,
        right: 0,
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messageReply!.isMe
                      ? 'Đang trả lời chính bạn'
                      : 'Đang trả lời: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w200,
                    color: greyColor,
                  ),
                ),
                Text(
                  messageReply.messageEnum == MessageEnum.text
                      ? messageReply.message
                      : messageReply.messageEnum.type,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (messageReply.messageEnum == MessageEnum.image ||
                  messageReply.messageEnum == MessageEnum.gif ||
                  messageReply.messageEnum == MessageEnum.video)
                SizedBox(
                  height: 40,
                  width: 40,
                  child: DisplayTextImageGif(
                    message: messageReply.message,
                    type: messageReply.messageEnum,
                  ),
                ),
              const SizedBox(width: 5),
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  size: 14,
                ),
                onTap: () => cancelReply(ref),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
