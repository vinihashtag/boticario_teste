import 'package:boticario/app/shared/models/post_model.dart';
import 'package:boticario/app/shared/utils/database.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sqflite/sqflite.dart';

class PostRepository extends Disposable {
  static final _table = "posts";

  Future<Database> _database() {
    return DatabaseHelper.instance.database;
  }

  // * Insere Post no banco de dados
  Future<int> insert(PostModel row) async {
    final Database db = await _database();
    try {
      return await db.insert(_table, row.toMap());
    } catch (error) {
      print(error);
    }
    return null;
  }

  // * Lista todos os Posts
  Future<List<PostModel>> queryAllRows() async {
    final Database db = await _database();
    try {
      final users = await db.query(_table);

      return users.map((e) => PostModel.fromMap(e)).toList();
    } catch (error) {
      print(error);
    }
    return null;
  }

  // * Lista todos Posts
  Future<List<PostModel>> getPostsUser(int id) async {
    final Database db = await _database();
    try {
      final users =
          await db.query(_table, where: 'user_id = ?', whereArgs: [id]);

      return users.map((e) => PostModel.fromMap(e)).toList();
    } catch (error) {
      print(error);
    }
    return null;
  }

  /// * Retorna a quantidade registros
  Future<int> queryRowCount() async {
    final Database db = await _database();
    try {
      return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $_table'));
    } catch (error) {
      print(error);
    }
    return null;
  }

  // * Atualiza a Post
  Future<int> update(PostModel row) async {
    final Database db = await _database();
    try {
      return await db
          .update(_table, row.toMap(), where: 'id = ?', whereArgs: [row.id]);
    } catch (error) {
      print(error);
    }
    return null;
  }

  // * Delete a Post
  Future<int> delete(int id) async {
    final Database db = await _database();
    try {
      return await db.delete(_table, where: 'id = ?', whereArgs: [id]);
    } catch (error) {
      print(error);
    }
    return null;
  }

  // * Busca a Post pelo id
  Future<PostModel> findById(int id) async {
    final Database db = await _database();
    try {
      List<Map<String, dynamic>> maps = await db.query("$_table",
          // columns: ["id", "name", "date_modification", "date_create"],
          where: 'id = ?',
          whereArgs: [id]);

      if (maps.first.length > 0) {
        return PostModel.fromMap(maps.first);
      }
    } catch (error) {
      print(error);
    }

    return null;
  }

  @override
  void dispose() {}
}
