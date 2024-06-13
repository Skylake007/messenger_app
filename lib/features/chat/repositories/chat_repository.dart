import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger_app/common/enums/message_enum.dart';
import 'package:messenger_app/common/providers/message_reply_provider.dart';
import 'package:messenger_app/common/repositories/common_firebase_storage_repository.dart';
import 'package:messenger_app/common/utils/utils.dart';
import 'package:messenger_app/models/chat_contact.dart';
import 'package:messenger_app/models/message.dart';
import 'package:messenger_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var doc in event.docs) {
        var chatContact = ChatContact.fromMap(doc.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> message = [];
      for (var doc in event.docs) {
        message.add(Message.fromMap(doc.data()));
      }
      return message;
    });
  }

  void _saveDataToContactSubCollection(
    UserModel senderUserData,
    UserModel recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    //users -> reciever user id  => chats -> current user id -> set data
    var recieverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          recieverChatContact.toMap(),
        );

    //users -> reciever user id  => chats -> current user id -> set data
    var senderChatContact = ChatContact(
      name: recieverUserData.name,
      profilePic: recieverUserData.profilePic,
      contactId: recieverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required recieverUsername,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required String recieverUserName,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverId: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : recieverUserName,
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  void sentTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    //users > sender id -> reciever id -> messages id -> store massage
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);
      _saveDataToContactSubCollection(
        senderUser,
        recieverUserData,
        text,
        timeSent,
        recieverUserId,
      );

      var messageId = const Uuid().v1();
      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        recieverUsername: recieverUserData.name,
        userName: senderUser.name,
        messageReply: messageReply,
        recieverUserName: recieverUserData.name,
        senderUsername: senderUser.name,
      );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
              file);
      UserModel recieverUserData;
      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);
      String contactMgs;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMgs = 'Hình ảnh';
          break;
        case MessageEnum.video:
          contactMgs = 'Video';
          break;
        case MessageEnum.audio:
          contactMgs = 'Âm thanh';
          break;
        case MessageEnum.gif:
          contactMgs = 'Gif';
          break;
        default:
          contactMgs = 'Tin nhắn';
          break;
      }
      _saveDataToContactSubCollection(
        senderUserData,
        recieverUserData,
        contactMgs,
        timeSent,
        recieverUserId,
      );
      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUserData.name,
        recieverUsername: recieverUserData.name,
        messageType: messageEnum,
        messageReply: messageReply,
        recieverUserName: recieverUserData.name,
        senderUsername: senderUserData.name,
      );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  void sentGifMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);
      _saveDataToContactSubCollection(
        senderUser,
        recieverUserData,
        'GIF',
        timeSent,
        recieverUserId,
      );

      var messageId = const Uuid().v1();
      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageType: MessageEnum.gif,
        messageId: messageId,
        userName: senderUser.name,
        recieverUsername: recieverUserData.name,
        messageReply: messageReply,
        recieverUserName: recieverUserData.name,
        senderUsername: senderUser.name,
      );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }
}
