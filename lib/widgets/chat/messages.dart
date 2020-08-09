import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy(
                  'timeCreated',
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final chatDocuments = chatSnapshot.data.documents;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocuments.length,
                itemBuilder: (ctx, index) => Container(
                  child: MessageBubble(
                    chatDocuments[index]['text'],
                    chatDocuments[index]['userId'] == futureSnapshot.data.uid,
                    chatDocuments[index]['userName'],
                    chatDocuments[index]['userImage'],
                    key: ValueKey(
                      chatDocuments[index].documentID,
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
