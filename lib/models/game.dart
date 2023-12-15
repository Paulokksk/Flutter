import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  late String id;
  late String title;
  late String platform;
  late String genre;
  late String description;
  late String imageUrl;

  Game({
    required this.title,
    required this.platform,
    required this.genre,
    required this.description,
    required this.imageUrl,
  });

  // Construtor nomeado para criar uma instância de Game a partir de um DocumentSnapshot
  Game.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        title = snapshot['title'] ?? '',
        platform = snapshot['platform'] ?? '',
        genre = snapshot['genre'] ?? '',
        description = snapshot['description'] ?? '',
        imageUrl = snapshot['imageUrl'] ?? '';

  // Método para converter um Game em um Map para ser salvo no Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'platform': platform,
      'genre': genre,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
