import 'package:bookly_project/data/livro_repository.dart';
import 'package:flutter/material.dart';
import '../model/livro.dart';

class LivroController extends ChangeNotifier {
  final LivroRepository _repository = LivroRepository();
  List<Livro> livros = [];

  Future<void> fetchLivros() async {
    livros = await _repository.getAllLivros();
    notifyListeners();
  }

  Future<void> addLivro(Livro livro) async {
    await _repository.addLivro(livro);
    await fetchLivros();
  }

  Future<void> deleteLivro(int id) async {
    await _repository.deleteLivro(id);
    await fetchLivros();
  }

  Future<void> updateLivro(Livro livro) async {
    await _repository.updateLivro(livro);
    await fetchLivros();
  }
}
