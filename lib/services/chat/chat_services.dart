import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:second_fire_app/model/message.dart';

class ChatServics extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //SEND MESSAGES
  Future<void> sendMessage(String receiverId, String message) async {
    //get user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    //create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );
    //construct chat room id from current user id and receiver id(stored to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //sort the ids(this ensure the chat room id is always the same for any of people)
    String chatRoomId = ids
        .join("_"); //combine the ids into a single string to use as chatroomId
    //add new message to data base
    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //GET MESSAGES
  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    //construct chat room id from current user id and receiver id(stored to ensure uniqueness)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
