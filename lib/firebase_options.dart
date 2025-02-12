// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDdJZv4Td929RegOAxSsyH1GZzlzsV1oKQ',
    appId: '1:118891630230:web:e6a4609a6ccd5784217cb7',
    messagingSenderId: '118891630230',
    projectId: 'flash-chat-5f702',
    authDomain: 'flash-chat-5f702.firebaseapp.com',
    storageBucket: 'flash-chat-5f702.appspot.com',
    measurementId: 'G-F3FMPVMYM3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSdiv_fn9XBvgYNN-kC2NylYkta54VYqk',
    appId: '1:118891630230:android:2a0027260a5169de217cb7',
    messagingSenderId: '118891630230',
    projectId: 'flash-chat-5f702',
    storageBucket: 'flash-chat-5f702.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDnEMq6i5JdIqEjRklc6XJE9iBA71oEYQs',
    appId: '1:118891630230:ios:f20fd2e669acd20d217cb7',
    messagingSenderId: '118891630230',
    projectId: 'flash-chat-5f702',
    storageBucket: 'flash-chat-5f702.appspot.com',
    iosBundleId: 'com.example.flashChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDnEMq6i5JdIqEjRklc6XJE9iBA71oEYQs',
    appId: '1:118891630230:ios:f20fd2e669acd20d217cb7',
    messagingSenderId: '118891630230',
    projectId: 'flash-chat-5f702',
    storageBucket: 'flash-chat-5f702.appspot.com',
    iosBundleId: 'com.example.flashChat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDdJZv4Td929RegOAxSsyH1GZzlzsV1oKQ',
    appId: '1:118891630230:web:e306e0121cdf7eb3217cb7',
    messagingSenderId: '118891630230',
    projectId: 'flash-chat-5f702',
    authDomain: 'flash-chat-5f702.firebaseapp.com',
    storageBucket: 'flash-chat-5f702.appspot.com',
    measurementId: 'G-9GGZQ1TD55',
  );
}
