// ignore_for_file: non_constant_identifier_names, unused_local_variable, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_fire_app/pages/chatpage.dart';
import 'package:second_fire_app/services/auth/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User = FirebaseAuth.instance.currentUser!;
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void logout() {
    final authservise = Provider.of<AuthServices>(context, listen: false);
    authservise.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Durations.long1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF630436),
          title: const Text(
            "Chat By Hashem",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          actions: [
            IconButton(
              onPressed: logout,
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const TabBar(
                unselectedLabelColor: Color(0xFF630436),
                indicatorColor: Color(0xFF630436),
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.home,
                      color: Color(0xFF630436),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.star_rounded,
                      color: Color(0xFF630436),
                    ),
                  ),
                ]),
            Expanded(
                child:
                    TabBarView(children: [_buildUserList(), _buildUserList()]))
          ],
        ),
      ),
    );
  }

  //
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading ...');
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    //display all user
    if (_auth.currentUser!.email != data['users']) {
      return ListTile(
        leading: const Icon(
          Icons.person,
          color: Colors.grey,
        ),
        shape: const CircleBorder(),
        title: Text(
          data['email'].toString().split("@").first,
          style: const TextStyle(color: Color(0xFF630436)),
        ),
        subtitle: Text(data['email']),
        dense: true,
        selected: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                reciverUserEmail: data['email'],
                reciverUserId: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container(
        child: const Center(child: Text('no data')),
      );
    }
  }
}
