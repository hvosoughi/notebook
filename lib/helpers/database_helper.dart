import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notebook/model/word_model.dart';

class DatabaseHelper {
  DatabaseHelper._innerInstance();
  static final DatabaseHelper instance = DatabaseHelper._innerInstance();
  static Database _db;

  String notebook = 'notebook';
  String colId = 'id';
  String colPersian = 'persian';
  String colEnglish = 'english';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getExternalStorageDirectory();
    String path = dir.path + 'notebook.db';
    final todoListDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $notebook($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colEnglish TEXT, $colPersian TEXT)',
    );
  }

  Future<List<Map<String, dynamic>>> getWordMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(notebook);
    return result;
  }

  Future<List<Word>> getWordList() async {
    final List<Map<String, dynamic>> wordMapList = await getWordMapList();
    final List<Word> wordList = [];
    wordMapList.forEach((wordMap) {
      wordList.add(Word.fromMap(wordMap));
    });
    return wordList;
  }

  Future<int> insertWord(Word word) async {
    Database db = await this.db;
    final int result = await db.insert(
      notebook,
      word.toMap(),
    );
    return result;
  }

  Future<int> updateWord(Word word) async {
    Database db = await this.db;
    final int result = await db.update(
      notebook,
      word.toMap(),
      where: '$colId = ?',
      whereArgs: [word.id],
    );
    return result;
  }

  Future<int> deleteWord(Word word) async {
    Database db = await this.db;
    final int result = await db.delete(
      notebook,
      where: '$colId = ?',
      whereArgs: [word.id],
    );
    return result;
  }
}
