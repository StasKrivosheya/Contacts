import 'dart:io';

import 'package:contacts/src/models/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static const String _dBName = "contacts.db";
  static const String _userTableName = "User";

  static final DBProvider instance = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDB();
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dBName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('CREATE TABLE $_userTableName ('
        '${UserFields.id} $idType,'
        '${UserFields.login} $textType UNIQUE,'
        '${UserFields.password} $textType'
        ')');
  }

  Future<int> createUser(User user) async {
    final db = await instance.database;
    return db.insert(_userTableName, user.toJson());
  }

  Future<User?> readUser(int id) async {
    final db = await instance.database;
    User? result;

    final maps = await db.query(_userTableName,
        columns: UserFields.allFieldsNames,
        where: '${UserFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      result = User.fromJson(maps.first);
    }

    return result;
  }

  Future<List<User>> readAllUsers() async {
    final db = await instance.database;

    const orderBy = '${UserFields.login} ASC';
    final result = await db.query(_userTableName, orderBy: orderBy);

    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;

    return db.update(_userTableName, user.toJson(),
        where: '${UserFields.id} = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await instance.database;

    return db.delete(_userTableName,
        where: '${UserFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
