import 'package:cloud_firestore/cloud_firestore.dart';

class Livro {
  final String? id;
  final String titulo;
  final String autor;
  final DateTime dataLeitura;
  final bool lido;

  Livro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.dataLeitura,
    required this.lido,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'autor': autor,
      'dataLeitura': dataLeitura.toIso8601String(),
      'lido': lido,
    };
  }

  factory Livro.fromMap(Map<String, dynamic> map, String id) {
    return Livro(
      id: id,
      titulo: map['titulo'],
      autor: map['autor'],
      dataLeitura: DateTime.parse(map['dataLeitura']),
      lido: map['lido'] ?? false,
    );
  }

  factory Livro.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Livro.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }
}
