// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA4hv-ISETJu3qg-l_Weq_jEoAiVczCCWQ',
    appId: '1:1080219543683:web:0f1b47331ea410e0e713b6',
    messagingSenderId: '1080219543683',
    projectId: 'supclubs',
    authDomain: 'supclubs.firebaseapp.com',
    storageBucket: 'supclubs.appspot.com',
    measurementId: 'G-EY6J1545CW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAMfijnK_-H6V3RFxHgvTVPEzohMAoX5kg',
    appId: '1:1080219543683:android:27c50aeff2c0ed1ae713b6',
    messagingSenderId: '1080219543683',
    projectId: 'supclubs',
    storageBucket: 'supclubs.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAtLZuVJ90wie5Tfk5n0FUHVOVxKxQ8OHY',
    appId: '1:1080219543683:ios:5076acb1433deadbe713b6',
    messagingSenderId: '1080219543683',
    projectId: 'supclubs',
    storageBucket: 'supclubs.appspot.com',
    androidClientId: '1080219543683-4lsfs1qsfi8gd8kqq4mpuj7a0vlpgcnh.apps.googleusercontent.com',
    iosClientId: '1080219543683-l7us8j1r96v4t8jjghcu2458tql7faof.apps.googleusercontent.com',
    iosBundleId: 'com.example.supclubs',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAtLZuVJ90wie5Tfk5n0FUHVOVxKxQ8OHY',
    appId: '1:1080219543683:ios:959529d00cebd682e713b6',
    messagingSenderId: '1080219543683',
    projectId: 'supclubs',
    storageBucket: 'supclubs.appspot.com',
    androidClientId: '1080219543683-4lsfs1qsfi8gd8kqq4mpuj7a0vlpgcnh.apps.googleusercontent.com',
    iosClientId: '1080219543683-khj0ft2ium6dasjspo09uspbi6e4u4gv.apps.googleusercontent.com',
    iosBundleId: 'com.example.supclubs.RunnerTests',
  );
}
