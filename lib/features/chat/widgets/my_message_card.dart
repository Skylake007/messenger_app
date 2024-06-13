import 'package:flutter/material.dart';
import 'package:messenger_app/common/enums/message_enum.dart';
import 'package:messenger_app/features/chat/widgets/display_text_image_gif.dart';
import 'package:messenger_app/widgets/colors.dart';
import 'package:swipe_to/swipe_to.dart';

class MyMessageCard extends StatefulWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipeCallBack;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;
  final String userImage;

  const MyMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipeCallBack,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.isSeen,
    required this.userImage,
  });

  @override
  State<MyMessageCard> createState() => _MyMessageCardState();
}

class _MyMessageCardState extends State<MyMessageCard> {
  bool _isShowStatus = false;

  void onLeftSwipe(DragUpdateDetails details) {
    widget.onLeftSwipeCallBack();
  }

  void onClickItem() {
    setState(() {
      if (widget.type == MessageEnum.text) {
        _isShowStatus = !_isShowStatus;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isReplying = widget.repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: GestureDetector(
        onTap: onClickItem,
        child: Column(
          children: [
            if (_isShowStatus && widget.type == MessageEnum.text)
              Text(
                widget.date,
                style: const TextStyle(
                  color: greyColor,
                  fontSize: 12,
                ),
              ),
            Align(
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Stack(
                    children: [
                      Padding(
                        padding: widget.type == MessageEnum.text
                            ? const EdgeInsets.only(
                                left: 10,
                                right: 30,
                                top: 5,
                                bottom: 5,
                              )
                            : const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            if (isReplying) ...[
                              //bung rộng
                              Text(
                                widget.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: backgroundColor.withOpacity(0.3),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: DisplayTextImageGif(
                                  message: widget.repliedText,
                                  type: widget.repliedMessageType,
                                ),
                              ),
                              const SizedBox(height: 3),
                            ],
                            DisplayTextImageGif(
                              message: widget.message,
                              type: widget.type,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isShowStatus && widget.type == MessageEnum.text)
              const Padding(
                padding: EdgeInsets.only(left: 5, top: 5),
                child: Text(
                  'Đã xem',
                  style: TextStyle(
                    fontSize: 12,
                    color: greyColor,
                  ),
                ),
              ),
            if (widget.isSeen)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    right: 15,
                    bottom: 5,
                  ),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.userImage),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
