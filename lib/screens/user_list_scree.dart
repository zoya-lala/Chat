import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'profile_screen.dart';

class UserListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              var userData = user.data() as Map<String, dynamic>;

              String? profileImage = userData['profileImage'];
              String userName = userData['name'] ?? 'Unknown User';
              String userId = user.id;

              ImageProvider imageProvider;

              if (profileImage != null && profileImage.startsWith('/9j/')) {
                try {
                  final decodedBytes = base64Decode(profileImage);
                  imageProvider = MemoryImage(decodedBytes);
                } catch (e) {
                  imageProvider = AssetImage('images/pp.jpg');
                }
              } else {
                imageProvider = AssetImage('images/pp.jpg');
              }

              return ListTile(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(userId: userId),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: imageProvider,
                  ),
                ),
                title: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(receiverEmail: userName),
                      ),
                    );
                  },
                  child: Text(
                    userName,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
