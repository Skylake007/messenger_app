import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/common/enums/message_enum.dart';
import 'package:messenger_app/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGif({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();

    Widget buildMessage() {
      switch (type) {
        case MessageEnum.text:
          return Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          );
        case MessageEnum.audio:
          return StatefulBuilder(builder: (context, setState) {
            return IconButton(
              constraints: const BoxConstraints(
                minWidth: 60,
              ),
              onPressed: () async {
                if (isPlaying) {
                  await audioPlayer.pause();
                  setState(() {
                    isPlaying = false;
                  });
                } else {
                  await audioPlayer.play(UrlSource(message));
                  setState(() {
                    isPlaying = true;
                  });
                }
              },
              icon: Icon(
                isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
              ),
            );
          });
        case MessageEnum.video:
          return VideoPlayerItem(videoUrl: message);
        case MessageEnum.gif:
          return CachedNetworkImage(imageUrl: message);
        case MessageEnum.image:
          return StatefulBuilder(builder: (context, state) {
            return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(imageUrl: message)));
          });
        default:
          return const SizedBox.shrink(); // Trường hợp không xác định
      }
    }

    return buildMessage();
  }
}
