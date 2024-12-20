import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: _firestore.collection('users').doc(userId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('User data not found.'));
            }

            var user = snapshot.data!;
            var userData = user.data() as Map<String, dynamic>;

            String name = userData['name'] ?? 'Unknown User';
            String bio = userData['bio'] ?? 'No bio available';
            String email = userData['email'] ?? 'No email provided';
            String? profileImage = userData['profileImage'];

            ImageProvider imageProvider;

            if (profileImage != null && profileImage.startsWith('/9j/')) {
              try {
                final decodedBytes = base64Decode(profileImage);
                imageProvider = MemoryImage(decodedBytes);
              } catch (e) {
                imageProvider = AssetImage('assets/images/default-image.png');
              }
            } else {
              imageProvider = AssetImage('assets/images/default-image.png');
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: imageProvider,
                  ),
                  SizedBox(height: 16),
                  Text(
                    name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    bio,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Email: $email',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
