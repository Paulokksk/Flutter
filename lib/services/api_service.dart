import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mygamelist/models/game.dart';

class ApiService {
  Future<List<Game>> fetchGames() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('games').get();

      List<Game> games = querySnapshot.docs
          .map((doc) => Game.fromFirestore(doc))
          .toList();

      return games;
    } catch (e) {
      throw Exception('Erro ao carregar jogos: $e');
    }
  }

  Future<void> addGame(Game game) async {
    try {
      await FirebaseFirestore.instance.collection('games').add(game.toMap());
    } catch (e) {
      throw Exception('Erro ao adicionar jogo: $e');
    }
  }

  Future<void> editGame(String gameId, Map<String, dynamic> updatedGameData) async {
    try {
      await FirebaseFirestore.instance.collection('games').doc(gameId).update(updatedGameData);
    } catch (e) {
      throw Exception('Erro ao editar jogo: $e');
    }
  }

  Future<void> deleteGame(String gameId) async {
    try {
      await FirebaseFirestore.instance.collection('games').doc(gameId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar jogo: $e');
    }
  }
}
