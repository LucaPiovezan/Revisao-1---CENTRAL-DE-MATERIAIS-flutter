import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/material_evento.dart';

class MaterialRepository {
  Database? _database;

  Future<Database> get _db async {
    if (_database != null) return _database!;

    _database = await databaseFactoryFfiWeb.openDatabase(
      'central_materiais.db',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE materiais (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT NOT NULL,
              categoria TEXT NOT NULL,
              quantidade_disponivel INTEGER NOT NULL,
              quantidade_minima INTEGER NOT NULL
            )
          ''');
        },
      ),
    );

    return _database!;
  }

  Future<List<MaterialEvento>> listar() async {
    final db = await _db;
    final registros = await db.query(
      'materiais',
      orderBy: 'nome COLLATE NOCASE',
    );
    return registros.map(MaterialEvento.fromMap).toList();
  }

  Future<int> inserir(MaterialEvento material) async {
    final db = await _db;
    return db.insert('materiais', material.toMap());
  }

  Future<int> atualizar(MaterialEvento material) async {
    if (material.id == null) {
      throw ArgumentError(
        'O material precisa de um identificador para ser atualizado.',
      );
    }

    final db = await _db;
    return db.update(
      'materiais',
      material.toMap(),
      where: 'id = ?',
      whereArgs: [material.id],
    );
  }

  Future<int> excluir(int id) async {
    final db = await _db;
    return db.delete('materiais', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> existeNome(String nome, {int? ignorarId}) async {
    final db = await _db;
    final argumentos = <Object>[nome.trim().toLowerCase()];
    var where = 'LOWER(TRIM(nome)) = ?';

    if (ignorarId != null) {
      where += ' AND id != ?';
      argumentos.add(ignorarId);
    }

    final resultado = await db.query(
      'materiais',
      columns: ['id'],
      where: where,
      whereArgs: argumentos,
      limit: 1,
    );
    return resultado.isNotEmpty;
  }
}
