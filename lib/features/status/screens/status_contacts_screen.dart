import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger_app/common/loader.dart';
import 'package:messenger_app/features/status/controller/status_controller.dart';
import 'package:messenger_app/features/status/screens/status_screen.dart';
import 'package:messenger_app/models/status_model.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var statusData = snapshot.data![index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, StatusScreen.routeName,
                          arguments: statusData);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                statusData.username,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ]),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            statusData.profilePic,
                          ),
                          radius: 30,
                        ),
                      ),
                    ),
                  )
                ],
              );
            });
      },
    );
  }
}
