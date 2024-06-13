import 'package:flutter/material.dart';
import 'package:messenger_app/common/enums/message_enum.dart';
import 'package:messenger_app/features/chat/widgets/display_text_image_gif.dart';
import 'package:messenger_app/widgets/colors.dart';
import 'package:swipe_to/swipe_to.dart';

class SenderMessageCard extends StatefulWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipeCallBack;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;
  const SenderMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    required this.repliedText,
    required this.onRightSwipeCallBack,
    required this.username,
    required this.repliedMessageType,
    required this.isSeen,
  });

  @override
  State<SenderMessageCard> createState() => _SenderMessageCardState();
}

class _SenderMessageCardState extends State<SenderMessageCard> {
  bool _isShowStatus = false;

  void onRightSwipe(DragUpdateDetails details) {
    widget.onRightSwipeCallBack();
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
      onRightSwipe: onRightSwipe,
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Stack(
                    children: [
                      Padding(
                        padding: widget.type == MessageEnum.text
                            ? const EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                                left: 10,
                                right: 10,
                              )
                            : const EdgeInsets.all(2),
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Text(
                    'Đã xem',
                    style: TextStyle(
                      fontSize: 12,
                      color: greyColor,
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
