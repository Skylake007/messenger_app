import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger_app/common/enums/message_enum.dart';

class MessageReply {
  final bool isMe;
  final String message;
  final MessageEnum messageEnum;

  MessageReply(
      {required this.isMe, required this.message, required this.messageEnum});
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);
