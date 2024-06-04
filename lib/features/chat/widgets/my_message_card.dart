// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:messenger_app/common/enums/message_enum.dart';
import 'package:messenger_app/features/chat/widgets/display_text_image_gif.dart';
import 'package:messenger_app/widgets/colors.dart';
import 'package:swipe_to/swipe_to.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipeCallBack;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;

  const MyMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipeCallBack,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
  });

  void onLeftSwipe(DragUpdateDetails details) {
    onLeftSwipeCallBack();
  }

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 10,
                          right: 30,
                          top: 5,
                          bottom: 25,
                        )
                      : const EdgeInsets.only(
                          top: 5,
                          left: 5,
                          right: 5,
                          bottom: 20,
                        ),
                  child: DisplayTextImageGif(
                    message: message,
                    type: type,
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 2,
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: greyColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
