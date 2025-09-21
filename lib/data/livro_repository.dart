import '../data/database_helper.dart';
import '../model/livro.dart';

class LivroRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Livro>> getAllLivros() async {
    return await _dbHelper.getLivros();
  }

  Future<void> addLivro(Livro livro) async {
    await _dbHelper.insertLivro(livro);
  }

  Future<void> deleteLivro(int id) async {
    await _dbHelper.deleteLivro(id);
  }

  Future<void> updateLivro(Livro livro) async {
    if (livro.id == null) {
      throw Exception('Livro precisa ter ID para ser atualizado');
    }
    await _dbHelper.updateLivro(livro);
  }
}
