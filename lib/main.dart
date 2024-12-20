import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/firebase_options.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/input_details.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/user_list_scree.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: 'https://zaehvzhcpytgzdtvetdl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InphZWh2emhjcHl0Z3pkdHZldGRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ3MTY1NDksImV4cCI6MjA1MDI5MjU0OX0.I4iB8Ud3KabEZs-GqzSiuAMZ1c8ogfn8-EAVItloC7Q',
  );

  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/chat': (context) => ChatScreen(),
        '/input': (context) => InputDetailsScreen(),
        '/list': (context) => UserListScreen(),
      },
    );
  }
}
