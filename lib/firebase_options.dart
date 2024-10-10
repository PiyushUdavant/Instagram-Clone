// File generated by FlutterFire CLI.
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
    apiKey: 'AIzaSyC8-JLDfkuPoK26EalUHosvh0HNWTx-3G4',
    appId: '1:473297065423:web:58c37f60d293bb03bfaeba',
    messagingSenderId: '473297065423',
    projectId: 'instagram-clone-a8dac',
    authDomain: 'instagram-clone-a8dac.firebaseapp.com',
    storageBucket: 'instagram-clone-a8dac.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAeNK5mqkZjFWJUpvioiVoFTlTzLhwoWsc',
    appId: '1:473297065423:android:45c3e036101f5946bfaeba',
    messagingSenderId: '473297065423',
    projectId: 'instagram-clone-a8dac',
    storageBucket: 'instagram-clone-a8dac.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDd2Ii8MaZ0AHj-hG-4aJ_6h5bvQ1QjNos',
    appId: '1:473297065423:ios:c3e009bff82ca10dbfaeba',
    messagingSenderId: '473297065423',
    projectId: 'instagram-clone-a8dac',
    storageBucket: 'instagram-clone-a8dac.appspot.com',
    iosBundleId: 'com.example.instagramClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDd2Ii8MaZ0AHj-hG-4aJ_6h5bvQ1QjNos',
    appId: '1:473297065423:ios:c3e009bff82ca10dbfaeba',
    messagingSenderId: '473297065423',
    projectId: 'instagram-clone-a8dac',
    storageBucket: 'instagram-clone-a8dac.appspot.com',
    iosBundleId: 'com.example.instagramClone',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC8-JLDfkuPoK26EalUHosvh0HNWTx-3G4',
    appId: '1:473297065423:web:bee5f426f78679e1bfaeba',
    messagingSenderId: '473297065423',
    projectId: 'instagram-clone-a8dac',
    authDomain: 'instagram-clone-a8dac.firebaseapp.com',
    storageBucket: 'instagram-clone-a8dac.appspot.com',
  );
}
