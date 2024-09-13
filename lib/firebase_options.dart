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
    apiKey: 'AIzaSyAUl_bYWeAx-SJYrDqm9VPuZbfiDUd7d7c',
    appId: '1:613944436953:web:67344f3e0b87b345a6b6c8',
    messagingSenderId: '613944436953',
    projectId: 'uber-76235',
    authDomain: 'uber-76235.firebaseapp.com',
    storageBucket: 'uber-76235.appspot.com',
    measurementId: 'G-GVPP81C6G0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCN-F_GuqrjgclmIllrMna_vntLdf52KJw',
    appId: '1:613944436953:android:20fd475542caa6cda6b6c8',
    messagingSenderId: '613944436953',
    projectId: 'uber-76235',
    storageBucket: 'uber-76235.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1_RMRedtAywtvXzaO7mskFnmysbwHcaE',
    appId: '1:613944436953:ios:1e8724974db14e27a6b6c8',
    messagingSenderId: '613944436953',
    projectId: 'uber-76235',
    storageBucket: 'uber-76235.appspot.com',
    iosBundleId: 'com.example.users',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD1_RMRedtAywtvXzaO7mskFnmysbwHcaE',
    appId: '1:613944436953:ios:1e8724974db14e27a6b6c8',
    messagingSenderId: '613944436953',
    projectId: 'uber-76235',
    storageBucket: 'uber-76235.appspot.com',
    iosBundleId: 'com.example.users',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAUl_bYWeAx-SJYrDqm9VPuZbfiDUd7d7c',
    appId: '1:613944436953:web:28fb543700f1d476a6b6c8',
    messagingSenderId: '613944436953',
    projectId: 'uber-76235',
    authDomain: 'uber-76235.firebaseapp.com',
    storageBucket: 'uber-76235.appspot.com',
    measurementId: 'G-NE6J5J0H1R',
  );
}
