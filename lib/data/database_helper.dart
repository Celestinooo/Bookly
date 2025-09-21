import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../model/livro.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bookly.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE livros(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        autor TEXT NOT NULL,
        dataLeitura TEXT NOT NULL,
        lido INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertLivro(Livro livro) async {
    final db = await instance.database;
    return await db.insert('livros', livro.toMap());
  }

  Future<List<Livro>> getLivros() async {
    final db = await instance.database;
    final result = await db.query('livros', orderBy: 'dataLeitura ASC');
    return result.map((map) => Livro.fromMap(map)).toList();
  }

  Future<int> deleteLivro(int id) async {
    final db = await instance.database;
    return await db.delete('livros', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateLivro(Livro livro) async {
    final db = await instance.database;
    return await db.update('livros', livro.toMap(), where: 'id = ?', whereArgs: [livro.id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
