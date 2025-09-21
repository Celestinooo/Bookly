import 'package:intl/intl.dart';

class Livro {
  final int? id;
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
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'dataLeitura': DateFormat('yyyy-MM-dd').format(dataLeitura),
      'lido': lido ? 1 : 0,
    };
  }

  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      id: map['id'],
      titulo: map['titulo'],
      autor: map['autor'],
      dataLeitura: DateTime.parse(map['dataLeitura']),
      lido: map['lido'] == 1,
    );
  }
}
