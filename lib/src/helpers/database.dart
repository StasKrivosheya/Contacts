import 'dart:io';

import 'package:contacts/src/models/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static const String _dBName = "contacts.db";

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

    await db.execute('CREATE TABLE ${UserFields.databaseTableName} ('
        '${UserFields.id} $idType,'
        '${UserFields.login} $textType UNIQUE,'
        '${UserFields.password} $textType'
        ')');

    // TODO: create other tables
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
