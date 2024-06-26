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
    apiKey: 'AIzaSyC_lMAS6fURjx777dI6-ImvOe6KMd0yGVw',
    appId: '1:662921758138:web:3c2a0c19b692ba4dcc0983',
    messagingSenderId: '662921758138',
    projectId: 'messengerappbackend',
    authDomain: 'messengerappbackend.firebaseapp.com',
    storageBucket: 'messengerappbackend.appspot.com',
    measurementId: 'G-2TP8FNC5W7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAw-XV08a44us_lGQxzHw0Oc6oUquZYzQ0',
    appId: '1:662921758138:android:221bca7155130852cc0983',
    messagingSenderId: '662921758138',
    projectId: 'messengerappbackend',
    storageBucket: 'messengerappbackend.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5HrU4K8tlKZtQv1L2PCREyajwncy4bqk',
    appId: '1:662921758138:ios:d7e0e57852246a16cc0983',
    messagingSenderId: '662921758138',
    projectId: 'messengerappbackend',
    storageBucket: 'messengerappbackend.appspot.com',
    iosBundleId: 'com.example.messengerApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5HrU4K8tlKZtQv1L2PCREyajwncy4bqk',
    appId: '1:662921758138:ios:d7e0e57852246a16cc0983',
    messagingSenderId: '662921758138',
    projectId: 'messengerappbackend',
    storageBucket: 'messengerappbackend.appspot.com',
    iosBundleId: 'com.example.messengerApp',
  );
}
