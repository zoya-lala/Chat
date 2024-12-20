import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  final String? receiverEmail;
  ChatScreen({this.receiverEmail});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _supabase = Supabase.instance.client;
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> _getChatMessages() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('messages')
          .where('sender', isEqualTo: currentUser.email)
          .where('receiver', isEqualTo: widget.receiverEmail)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      return Stream.empty();
    }
  }

  Future<void> _uploadDocumentToSupabase(
      File file, String fileName, BuildContext context) async {
    try {
      final response =
          await _supabase.storage.from('docs').upload(fileName, file);

      String documentUrl =
          _supabase.storage.from('docs').getPublicUrl(fileName);

      await sendMessage('document', content: documentUrl, fileName: fileName);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Document uploaded successfully')));
    } catch (e) {
      print('Error during document upload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during document upload')));
    }
  }

  Future<void> _uploadVideoToSupabase(
      File file, String fileName, BuildContext context) async {
    try {
      final response =
          await _supabase.storage.from('videos').upload(fileName, file);

      String videoUrl = _supabase.storage.from('videos').getPublicUrl(fileName);

      await sendMessage('video', content: videoUrl, fileName: fileName);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Video uploaded successfully')));
    } catch (e) {
      print('Error during video upload: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error during video upload')));
    }
  }

  Future<void> sendMessage(String type,
      {String? content, String? fileName}) async {
    if (_auth.currentUser == null || widget.receiverEmail == null) return;

    await FirebaseFirestore.instance.collection('messages').add({
      'sender': _auth.currentUser!.email,
      'receiver': widget.receiverEmail,
      'participants': [_auth.currentUser!.email, widget.receiverEmail],
      'content': content,
      'fileName': fileName,
      'timestamp': FieldValue.serverTimestamp(),
      'type': type,
    });
  }

  Future<void> _pickFile(String fileType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      File pickedFile = File(file.path!);
      String fileName = file.name;

      if (fileType == 'document') {
        await _uploadDocumentToSupabase(pickedFile, fileName, context);
      } else if (fileType == 'video') {
        await _uploadVideoToSupabase(pickedFile, fileName, context);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No file selected!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail ?? 'Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getChatMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs.map((doc) {
                  return doc.data() as Map<String, dynamic>;
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    bool isSender =
                        messages[index]['sender'] == _auth.currentUser!.email;
                    String content = messages[index]['content'] ?? '';
                    String type = messages[index]['type'] ?? 'text';
                    String fileName = messages[index]['fileName'] ?? 'Unknown';

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSender ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: type == 'text'
                              ? Text(content)
                              : InkWell(
                                  onTap: () {},
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        type == 'document'
                                            ? 'Document: $fileName'
                                            : 'Video: $fileName',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Upload File'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text('Upload Document'),
                                onTap: () async {
                                  await _pickFile('document');
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                title: Text('Upload Video'),
                                onTap: () async {
                                  await _pickFile('video');
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type your message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String text = _controller.text;
                    if (text.isNotEmpty) {
                      sendMessage('text', content: text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
