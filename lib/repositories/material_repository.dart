
import '../models/material_evento.dart';
import '../services/database_service.dart';

class MaterialRepository {
  final DatabaseService service;

  MaterialRepository(this.service);

  // Lista os materiais cadastrados.
  Future<List<MaterialEvento>> listar() async {
    final db = await service.database;

    final linhas = await db.query(
      'materiais',
      orderBy: 'nome COLLATE NOCASE',
    );

    return linhas
        .map((linha) => MaterialEvento.fromMap(linha))
        .toList();
  }

  // TODO 4: Verifica se já existe um material com o nome.
  Future<bool> existeNome(String nome, {int? ignorarId}) async {
    final db = await service.database;

    final nomeNormalizado = nome.trim().toLowerCase();

    final linhas = await db.query(
      'materiais',
      columns: ['id'],
      where: ignorarId == null
          ? 'nome_normalizado = ?'
          : 'nome_normalizado = ? AND id != ?',
      whereArgs: ignorarId == null
          ? [nomeNormalizado]
          : [nomeNormalizado, ignorarId],
      limit: 1,
    );

    return linhas.isNotEmpty;
  }

  // TODO 5: Cadastra um novo material.
  Future<void> inserir(MaterialEvento material) async {
    final db = await service.database;

    await db.insert(
      'materiais',
      material.toMap(),
    );
  }

  // TODO 6: Atualiza somente o material selecionado.
  Future<void> atualizar(MaterialEvento material) async {
    final db = await service.database;

    if (material.id == null) {
      throw ArgumentError('O material precisa ter um ID.');
    }

    await db.update(
      'materiais',
      material.toMap(),
      where: 'id = ?',
      whereArgs: [material.id],
    );
  }

  // TODO 7: Exclui somente o material selecionado.
  Future<void> excluir(int id) async {
    final db = await service.database;

    await db.delete(
      'materiais',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
