// firebase_options.dart

import 'package:firebase_core/firebase_core.dart';

class FirebaseOptionsConfig {
  static FirebaseOptions getOptions() {
    return const FirebaseOptions(
      apiKey: 'AIzaSyAf8B7rtlyskD-SGUF2t0uKjm5QaXrLqCU',
      authDomain: 'localhost',
      projectId: 'my-game-paulo',
      storageBucket: 'my-game-paulo.appspot.com',
      messagingSenderId: '140278541073',
      appId: '140278541073',
    );
  }
}
