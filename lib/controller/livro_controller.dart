import 'package:flutter/material.dart';
import '../model/livro.dart';
import '../data/livro_repository.dart';

class LivroController extends ChangeNotifier {
  final LivroRepository _repository = LivroRepository();
  List<Livro> livros = [];
  bool isLoading = true;

  Future<void> fetchLivros() async {
    isLoading = true;
    notifyListeners();

    livros = await _repository.getAllLivros();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addLivro(Livro livro) async {
    await _repository.addLivro(livro);
    await fetchLivros();
  }

  Future<void> deleteLivro(String id) async {
    await _repository.deleteLivro(id);
    await fetchLivros();
  }

  Future<void> updateLivro(Livro livro) async {
    await _repository.updateLivro(livro);
    await fetchLivros();
  }
}
