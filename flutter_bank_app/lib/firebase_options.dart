import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static Future<void> load() async {
    await dotenv.load(fileName: "assets/.env");
  }

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

  static FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY']!,
    appId: dotenv.env['FIREBASE_APP_ID']!,
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN']!,
    databaseURL:
        'https://bank-app-722aa-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY']!,
    appId: dotenv.env['FIREBASE_APP_ID']!,
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    databaseURL:
        'https://bank-app-722aa-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY']!,
    appId: dotenv.env['FIREBASE_APP_ID']!,
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    databaseURL:
        'https://bank-app-722aa-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
    iosBundleId: 'com.example.flutterBankApp',
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY']!,
    appId: dotenv.env['FIREBASE_APP_ID']!,
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    databaseURL:
        'https://bank-app-722aa-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
    iosBundleId: 'com.example.flutterBankApp',
  );

  static FirebaseOptions windows = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY']!,
    appId: dotenv.env['FIREBASE_APP_ID']!,
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN']!,
    databaseURL:
        'https://bank-app-722aa-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
  );
}
