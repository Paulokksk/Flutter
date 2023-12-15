import 'package:flutter/material.dart';
import 'package:mygamelist/screens/game_library_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAf8B7rtlyskD-SGUF2t0uKjm5QaXrLqCU',
      authDomain: 'localhost',
      projectId: 'my-game-paulo',
      storageBucket: 'my-game-paulo.appspot.com',
      messagingSenderId: '140278541073',
      appId: '140278541073',
    ),
  );

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Jogos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const GameLibraryScreen(),
    );
  }
}
