// File: lib/core/config/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with Firebase.initializeApp.
/// Configure with real project credentials via FlutterFire CLI if needed.
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
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyWebLedgerFlow000000000000',
    appId: '1:100000000000:web:ledgerflow000000000',
    messagingSenderId: '100000000000',
    projectId: 'ledger-flow-app',
    authDomain: 'ledger-flow-app.firebaseapp.com',
    storageBucket: 'ledger-flow-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8rc7-k_vISIO4qBVXVrDEzYj7j4gpWO0',
    appId: '1:242049436022:android:544fb26802b9e2b8461257',
    messagingSenderId: '242049436022',
    projectId: 'ledgerflow-2b7da',
    storageBucket: 'ledgerflow-2b7da.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyIOSLedgerFlow0000000000',
    appId: '1:100000000000:ios:ledgerflow00000000000',
    messagingSenderId: '100000000000',
    projectId: 'ledger-flow-app',
    storageBucket: 'ledger-flow-app.appspot.com',
    iosBundleId: 'com.ledgerflow.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyMacOSLedgerFlow000000000',
    appId: '1:100000000000:ios:ledgerflow00000000000',
    messagingSenderId: '100000000000',
    projectId: 'ledger-flow-app',
    storageBucket: 'ledger-flow-app.appspot.com',
    iosBundleId: 'com.ledgerflow.app',
  );
}
