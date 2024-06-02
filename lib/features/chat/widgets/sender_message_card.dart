import 'package:flutter/material.dart';
import 'package:messenger_app/common/enums/message_enum.dart';
import 'package:messenger_app/features/chat/widgets/display_text_image_gif.dart';
import 'package:messenger_app/widgets/colors.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  const SenderMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
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
                        bottom: 25,
                      ),
                child: DisplayTextImageGif(
                  message: message,
                  type: type,
                ),
              ),
              Positioned(
                left: 15,
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
    );
  }
}
