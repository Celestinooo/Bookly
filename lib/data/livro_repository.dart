import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/livro.dart';

class LivroRepository {
  final CollectionReference _livrosRef =
  FirebaseFirestore.instance.collection('livros');

  Future<List<Livro>> getAllLivros() async {
    final snapshot = await _livrosRef.orderBy('dataLeitura').get();
    return snapshot.docs
        .map((doc) => Livro.fromDocumentSnapshot(doc))
        .toList();
  }

  Future<void> addLivro(Livro livro) async {
    await _livrosRef.add(livro.toMap());
  }

  Future<void> deleteLivro(String id) async {
    await _livrosRef.doc(id).delete();
  }

  Future<void> updateLivro(Livro livro) async {
    if (livro.id == null) throw Exception('Livro precisa ter ID');
    await _livrosRef.doc(livro.id).update(livro.toMap());
  }
}
