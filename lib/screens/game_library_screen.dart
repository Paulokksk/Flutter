import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mygamelist/models/game.dart';
import 'package:mygamelist/screens/game_details_screen.dart';

class GameLibraryScreen extends StatefulWidget {
  const GameLibraryScreen({Key? key}) : super(key: key);

  @override
  _GameLibraryScreenState createState() => _GameLibraryScreenState();
}
  late File _imageFile;  // Adicione esta linha
  late String _selectedGameId;
class _GameLibraryScreenState extends State<GameLibraryScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _gamesStream;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _platformController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  late String _selectedGameId;

  @override
  void initState() {
    super.initState();
    _gamesStream = FirebaseFirestore.instance.collection('games').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Biblioteca de Jogos'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: _gamesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar jogos'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('Nenhum dado disponível'),
            );
          } else {
            QuerySnapshot<Map<String, dynamic>> gamesSnapshot = snapshot.data!;
            List<Game> games = gamesSnapshot.docs
                .map((document) => Game.fromFirestore(document as QueryDocumentSnapshot<Map<String, dynamic>>))
                .toList();

            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            games[index].title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditGameDialog(context, games[index]);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteGameDialog(context, games[index]);
                          },
                        ),
                      ],
                    ),
                    subtitle: Text('Plataforma: ${games[index].platform}'),
                    onTap: () {
                      _navigateToGameDetailsScreen(context, games[index].id as String);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGameDialog(context);
        },
        tooltip: 'Adicionar Jogo',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddGameDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Novo Jogo'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: _platformController,
                  decoration: const InputDecoration(labelText: 'Plataforma'),
                ),
                TextField(
                  controller: _genreController,
                  decoration: const InputDecoration(labelText: 'Gênero'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
                ),
                TextField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'URL da Imagem'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text('Adicionar'),
              onPressed: () async {
                await _addGameToFirestore();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addGameToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('games').add({
        'title': _titleController.text,
        'platform': _platformController.text,
        'genre': _genreController.text,
        'description': _descriptionController.text,
        'imageUrl': _imageUrlController.text,
      });

      _clearControllers();
    } catch (e) {
      print('Erro ao adicionar jogo: $e');
    }
  }

  Future<void> _showGameOptionsDialog(BuildContext context, Game game) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Opções do Jogo'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Editar Jogo'),
                  onTap: () {
                    _showEditGameDialog(context, game);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Deletar Jogo'),
                  onTap: () {
                    _showDeleteGameDialog(context, game);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showEditGameDialog(BuildContext context, Game game) async {
    _titleController.text = game.title;
    _platformController.text = game.platform;
    _genreController.text = game.genre;
    _descriptionController.text = game.description;
    _imageUrlController.text = game.imageUrl;
    _selectedGameId = game.id as String;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Jogo'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: _platformController,
                  decoration: const InputDecoration(labelText: 'Plataforma'),
                ),
                TextField(
                  controller: _genreController,
                  decoration: const InputDecoration(labelText: 'Gênero'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
                ),
                TextField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'URL da Imagem'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text('Salvar'),
              onPressed: () async {
                await _editGameInFirestore();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editGameInFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('games').doc(_selectedGameId).update({
        'title': _titleController.text,
        'platform': _platformController.text,
        'genre': _genreController.text,
        'description': _descriptionController.text,
        'imageUrl': _imageUrlController.text,
      });

      _clearControllers();
    } catch (e) {
      print('Erro ao editar jogo: $e');
    }
  }

  Future<void> _showDeleteGameDialog(BuildContext context, Game game) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deletar Jogo'),
          content: Text('Tem certeza de que deseja deletar "${game.title}"?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text('Deletar'),
              onPressed: () async {
                await _deleteGameFromFirestore(game.id as String);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteGameFromFirestore(String gameId) async {
    try {
      await FirebaseFirestore.instance.collection('games').doc(gameId).delete();
    } catch (e) {
      print('Erro ao deletar jogo: $e');
    }
  }

  void _navigateToGameDetailsScreen(BuildContext context, String gameId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameDetailsScreen(gameId: gameId),
      ),
    );
  }

  void _clearControllers() {
    _titleController.clear();
    _platformController.clear();
    _genreController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
  }
}
