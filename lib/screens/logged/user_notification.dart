import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/notification_provider.dart';

class UserNotificationScreen extends StatefulWidget {
  const UserNotificationScreen({super.key});

  @override
  State<UserNotificationScreen> createState() => _UserNotificationScreenState();
}

class _UserNotificationScreenState extends State<UserNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final notificationCount = Provider.of<NotificationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông báo (${notificationCount.getNotificationCount()})',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userNotification')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('notifications')
            .orderBy('id', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount:
                  snapshot.data!.docs.isEmpty ? 0 : snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: ListTile(
                    isThreeLine: true,
                    onTap: () {
                      snapshot.data!.docs[index]['isRead'] == 'unread'
                          ? notificationCount
                              .markRead(snapshot.data!.docs[index].id)
                          : null;
                    },
                    title: Text(
                      snapshot.data!.docs[index]['title'],
                      style: const TextStyle(fontSize: 22),
                    ),
                    subtitle: snapshot.data!.docs[index]
                                ['isWelcomeNotification'] ==
                            'yes'
                        ? Text('${snapshot.data!.docs[index]['content']}',
                            style: const TextStyle(fontSize: 20))
                        : Text(
                            '${snapshot.data!.docs[index]['content']}\n${snapshot.data!.docs[index]['dateTime']}',
                            style: const TextStyle(fontSize: 20)),
                    leading: snapshot.data!.docs[index]['isRead'] == 'unread'
                        ? const Icon(
                            Icons.mark_email_unread_outlined,
                            size: 25,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.mark_email_read_outlined,
                            color: Colors.teal,
                            size: 25,
                          ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
