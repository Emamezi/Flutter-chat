import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _userMessage = '';

  final _messageController = TextEditingController();

  void _sendMessage() async {
    // sending the user mssage to the database
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add({
      'text': _userMessage,
      'timeCreated': Timestamp.now(),
      'userId': user.uid,
      'userName': userData['username'],
      'userImage': userData['image_url'],
    });
    _messageController.clear();
    _userMessage = '';

    // print(Timestamp.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              onChanged: (value) {
                setState(() {
                  _userMessage = value;
                });
              },
              decoration: InputDecoration(labelText: 'Enter a message'),
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _userMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
