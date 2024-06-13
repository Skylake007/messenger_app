import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger_app/common/utils/utils.dart';
import 'package:messenger_app/features/auth/controller/auth_controller.dart';
import 'package:messenger_app/features/group/screens/create_group_screen.dart';
import 'package:messenger_app/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:messenger_app/features/status/screens/confirm_status_screen.dart';
import 'package:messenger_app/features/status/screens/status_contacts_screen.dart';
import 'package:messenger_app/widgets/colors.dart';
import 'package:messenger_app/features/chat/widgets/contact_list.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({super.key});

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tabBarController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarColor,
        centerTitle: false,
        title: const Text(
          'Đoạn chat',
          style: TextStyle(
              fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: greyColor,
              ),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Tạo nhóm'),
                      onTap: () => Future(
                        () => Navigator.pushNamed(
                            context, CreateGroupScreen.routeName),
                      ),
                    ),
                  ])
        ],
        bottom: TabBar(
          controller: tabBarController,
          indicatorColor: tabColor,
          indicatorWeight: 4,
          labelColor: tabColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Chat'),
            Tab(text: 'Status'),
            Tab(text: 'Video Call'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabBarController,
        children: const [
          ContactsList(),
          StatusContactsScreen(),
          Text('Calls'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (tabBarController.index == 0) {
            Navigator.pushNamed(context, SelectContactScreen.routeName);
          } else {
            File? pickImage = await pickImageFromGallery(context);
            if (pickImage != null && context.mounted) {
              Navigator.pushNamed(context, ConfirmStatusScreen.routeName,
                  arguments: pickImage);
            }
          }
        },
        backgroundColor: tabColor,
        child: const Icon(Icons.comment),
      ),
    );
  }
}
