import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger_app/common/enums/message_enum.dart';
import 'package:messenger_app/common/utils/utils.dart';
import 'package:messenger_app/features/chat/controller/chat_controller.dart';
import 'package:messenger_app/widgets/colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const BottomChatField({
    super.key,
    required this.recieverUserId,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController controller = TextEditingController();
  bool isTyping = false;

  void sendTextMessage() async {
    if (isTyping) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            controller.text.trim(),
            widget.recieverUserId,
          );
      setState(() {
        controller.text = '';
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum type,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.recieverUserId,
          type,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  isTyping = true;
                });
              } else {
                setState(() {
                  isTyping = false;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.emoji_emotions,
                              color: Colors.grey)),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.gif),
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.camera_alt, color: Colors.grey)),
                    IconButton(
                        onPressed: selectVideo,
                        icon:
                            const Icon(Icons.attach_file, color: Colors.grey)),
                  ],
                ),
              ),
              hintText: 'Nhập tin nhắn',
              hintStyle: const TextStyle(color: greyColor, fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 2, left: 2),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF128C7E),
            radius: 25,
            child: GestureDetector(
              child: Icon(isTyping ? Icons.send : Icons.mic),
              onTap: () => sendTextMessage(),
              onLongPress: () {
                // record
              },
            ),
          ),
        )
      ],
    );
  }
}
