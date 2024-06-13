import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger_app/common/repositories/common_firebase_storage_repository.dart';
import 'package:messenger_app/common/utils/utils.dart';
import 'package:messenger_app/models/status_model.dart';
import 'package:messenger_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider((ref) => StatusRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      ref: ref,
    ));

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            '/status/$statusId$uid',
            statusImage,
          );

      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      List<String> uidWhoCanSee = [];

      for (int i = 0; i < contacts.length; i++) {
        String formatPhone;
        if (contacts[i].phones.isNotEmpty) {
          formatPhone = contacts[i]
              .phones[0]
              .number
              .replaceAll(' ', '')
              .replaceFirst('0', '+84')
              .trim();
        } else {
          formatPhone = '';
        }

        var userDataFirebase = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: formatPhone,
            )
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
        }
      }

      List<String> statusImageUrls = [];
      var statusSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();

      if (statusSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await firestore
            .collection('status')
            .doc(statusSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageUrl];
      }

      Status status = Status(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firestore.collection('status').doc(statusId).set(status.toMap());
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i = 0; i < contacts.length; i++) {
        String formatPhone;
        if (contacts[i].phones.isNotEmpty) {
          formatPhone = contacts[i]
              .phones[0]
              .number
              .replaceAll(' ', '')
              .replaceFirst('0', '+84')
              .trim();
          print('format phone: $formatPhone');
        } else {
          formatPhone = '';
        }

        var statusesSnapshot = await firestore
            .collection('status')
            .where('phoneNumber', isEqualTo: formatPhone)
            .where('createAt',
                isGreaterThan: DateTime.now()
                    .subtract(const Duration(hours: 24))
                    .millisecondsSinceEpoch)
            .get();

        for (var tempData in statusesSnapshot.docs) {
          Status tempStatus = Status.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
    return statusData;
  }
}
