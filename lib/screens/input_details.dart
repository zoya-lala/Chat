import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InputDetailsScreen extends StatefulWidget {
  @override
  _InputDetailsScreenState createState() => _InputDetailsScreenState();
}

class _InputDetailsScreenState extends State<InputDetailsScreen> {
  final _firestore = FirebaseFirestore.instance;
  final picker = ImagePicker();

  String? name;
  String? bio;
  File? _profileImage;
  bool isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      print("Image selected: ${pickedFile.path}");
    } else {
      print("No image selected");
    }
  }

  Future<String?> _convertImageToBase64(File image) async {
    try {
      final bytes = await image.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Error encoding image to Base64: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.grey[700],
                      )
                    : null,
              ),
            ),
            SizedBox(height: 24.0),
            TextField(
              keyboardType: TextInputType.name,
              textAlign: TextAlign.center,
              onChanged: (value) {
                name = value;
              },
              decoration: kTextFieldDec.copyWith(hintText: 'Enter your name'),
            ),
            SizedBox(height: 8.0),
            TextField(
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              onChanged: (value) {
                bio = value;
              },
              decoration: kTextFieldDec.copyWith(hintText: 'Enter a short bio'),
            ),
            SizedBox(height: 24.0),
            RoundedButton(
              title: isUploading ? 'Uploading...' : 'Save & Continue',
              colour: Colors.blueAccent,
              onPressed: () async {
                if (name == null || bio == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                setState(() {
                  isUploading = true;
                });

                String? profileImageBase64;
                if (_profileImage != null) {
                  profileImageBase64 =
                      await _convertImageToBase64(_profileImage!);
                } else {
                  print("No profile image provided.");
                }

                final user = FirebaseAuth.instance.currentUser;

                print("Current user: ${user?.email} (UID: ${user?.uid})");

                if (user != null) {
                  try {
                    await _firestore.collection('users').doc(user.uid).set({
                      'name': name,
                      'bio': bio,
                      'email': user.email,
                      'profileImage': profileImageBase64 ?? '',
                    });

                    print("User details stored successfully in Firestore.");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile saved successfully!')),
                    );
                    Navigator.pushNamed(context, '/list');
                  } catch (e) {
                    print('Error saving user details: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Failed to save profile details.')),
                    );
                  }
                } else {
                  print("User is null.");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Failed to save profile user nuull.')),
                  );
                }

                setState(() {
                  isUploading = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
