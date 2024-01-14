import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_fire_app/components/my_txt_field.dart';
import 'package:second_fire_app/services/chat/chat_services.dart';

import '../components/chat_buble.dart';

class ChatPage extends StatefulWidget {
  final String reciverUserEmail;
  final String reciverUserId;
  const ChatPage({
    super.key,
    required this.reciverUserEmail,
    required this.reciverUserId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messagecontroller = TextEditingController();
  final ChatServics _chatservices = ChatServics();
  final FirebaseAuth _fireauth = FirebaseAuth.instance;
  void sendMessage() async {
    if (_messagecontroller.text.isNotEmpty) {
      await _chatservices.sendMessage(
          widget.reciverUserId, _messagecontroller.text);
      _messagecontroller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reciverUserEmail.split("@").first,
          style: const TextStyle(color: Colors.white),
        ),
        leading: Row(
          children: [
            const SizedBox(
              width: 7,
            ),
            GestureDetector(
              onTap: () {
                return Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ],
        ),
        backgroundColor: const Color(0xFF630436),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  //build Message List
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatservices.getMessage(
          widget.reciverUserId, _fireauth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            "Loading ...",
          );
        }
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  //build Message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _fireauth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _fireauth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _fireauth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(
              data['senderEmail'],
            ),
            const SizedBox(
              height: 5,
            ),
            ChatBubble(
              message: data['message'],
              color: (data['senderId'] == _fireauth.currentUser!.uid)
                  ? Colors.black
                  : const Color.fromARGB(255, 0, 80, 145),
            ),
          ],
        ),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
          obscureText: false,
          controller: _messagecontroller,
          decoration: InputDecoration(
              suffixIcon: const Icon(
                Icons.send,
                size: 40,
                color: Color(0xFF630436),
              ),
              hintText: 'Enter Message',
              fillColor: Colors.grey[400],
              filled: true,
              hintStyle: const TextStyle(color: Color(0xFF630436)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(30),
              )),
        ));
  }
}
